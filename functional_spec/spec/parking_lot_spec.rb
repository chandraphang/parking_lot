require 'spec_helper'

RSpec.describe 'Parking Lot' do
  let(:pty) { PTY.spawn('bin/parking_lot') }

  before(:each) do
    run_command(pty, "create_parking_lot 3\n")
  end

  it "can create a parking lot", :sample => true do
    expect(fetch_stdout(pty)).to end_with("Created a parking lot with 3 slots\n")
  end

  it "can park a car" do
    run_command(pty, "park KA-01-HH-3141 Black\n")
    expect(fetch_stdout(pty)).to end_with("Allocated slot number: 1\n")
  end
  
  it "can unpark a car" do
    run_command(pty, "park KA-01-HH-3141 Black\n")
    run_command(pty, "leave 1\n")
    expect(fetch_stdout(pty)).to end_with("Slot number 1 is free\n")
  end
  
  it "can report status" do
    run_command(pty, "park KA-01-HH-1234 White\n")
    run_command(pty, "park KA-01-HH-3141 Black\n")
    run_command(pty, "park KA-01-HH-9999 White\n")
    run_command(pty, "status\n")
    expect(fetch_stdout(pty)).to end_with(<<-EOTXT
Slot No.    Registration No    Colour
1           KA-01-HH-1234      White
2           KA-01-HH-3141      Black
3           KA-01-HH-9999      White
EOTXT
)
  end
  
  it "reinitialize parking list when new parking lot created" do
    run_command(pty, "park KA-01-HH-1234 White\n")
    run_command(pty, "status\n")
    expect(fetch_stdout(pty)).to end_with(<<-EOTXT
Slot No.    Registration No    Colour
1           KA-01-HH-1234      White
EOTXT
)
    # create new parking lot
    run_command(pty, "create_parking_lot 3\n")
    run_command(pty, "status\n")
    expect(fetch_stdout(pty)).to end_with(<<-EOTXT
Slot No.    Registration No    Colour
EOTXT
)
  end

  it "return invalid input messages if invalid input received" do
    run_command(pty, "this_is_invalid_input")
    expect(fetch_stdout(pty)).to end_with("Invalid input\n")
  end

  it "can unpark empty slot" do
    run_command(pty, "leave 1\n")
    expect(fetch_stdout(pty)).to end_with("Slot number 1 is free\n")
  end

  it "can showing full slot messages" do
    run_command(pty, "park KA-01-HH-1234 White\n")
    run_command(pty, "park KA-01-HH-3141 Black\n")
    run_command(pty, "park KA-01-HH-9999 White\n")
    run_command(pty, "park KA-01-HH-7777 Red\n")
    expect(fetch_stdout(pty)).to end_with("Sorry, parking lot is full\n")
  end

  it "can find_registration_number_by_colour" do
    run_command(pty, "park KA-01-HH-1234 White\n")
    run_command(pty, "park KA-01-HH-3141 Black\n")
    run_command(pty, "park KA-01-HH-9999 White\n")
    run_command(pty, "registration_numbers_for_cars_with_colour White\n")
    expect(fetch_stdout(pty)).to end_with("KA-01-HH-1234, KA-01-HH-9999\n")
    run_command(pty, "registration_numbers_for_cars_with_colour Black\n")
    expect(fetch_stdout(pty)).to end_with("KA-01-HH-3141\n")
    run_command(pty, "registration_numbers_for_cars_with_colour Red\n")
    expect(fetch_stdout(pty)).to end_with("Not found\n")
  end

  it "can find slot_numbers_for_cars_with_colour" do
    run_command(pty, "park KA-01-HH-1234 White\n")
    run_command(pty, "park KA-01-HH-3141 Black\n")
    run_command(pty, "park KA-01-HH-9999 White\n")
    run_command(pty, "slot_numbers_for_cars_with_colour White\n")
    expect(fetch_stdout(pty)).to end_with("1, 3\n")
    run_command(pty, "slot_numbers_for_cars_with_colour Black\n")
    expect(fetch_stdout(pty)).to end_with("2\n")
    run_command(pty, "slot_numbers_for_cars_with_colour Red\n")
    expect(fetch_stdout(pty)).to end_with("Not found\n")
  end

  it "can find slot_numbers_for_cars_with_colour" do
    run_command(pty, "park KA-01-HH-1234 White\n")
    run_command(pty, "park KA-01-HH-3141 Black\n")
    run_command(pty, "park KA-01-HH-9999 White\n")

    run_command(pty, "slot_numbers_for_cars_with_colour White\n")
    expect(fetch_stdout(pty)).to end_with("1, 3\n")

    run_command(pty, "slot_numbers_for_cars_with_colour Black\n")
    expect(fetch_stdout(pty)).to end_with("2\n")

    run_command(pty, "slot_numbers_for_cars_with_colour Red\n")
    expect(fetch_stdout(pty)).to end_with("Not found\n")
  end

  it "can find_slot_number_by_registration_number" do
    run_command(pty, "park KA-01-HH-1234 White\n")

    run_command(pty, "slot_number_for_registration_number KA-01-HH-1234\n")
    expect(fetch_stdout(pty)).to end_with("1\n")

    run_command(pty, "slot_number_for_registration_number 123456789\n")
    expect(fetch_stdout(pty)).to end_with("Not found\n")
  end
end
