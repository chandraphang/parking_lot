require 'byebug'

class ParkingList
  def initialize(registration_number:, colour:, status:)
    @registration_number = registration_number
    @colour = colour
    @status = status
  end

  attr_accessor :registration_number
  attr_accessor :status
  attr_accessor :colour
end

VALID_INPUT = [
  'create_parking_lot',
  'park',
  'leave',
  'status',
  'registration_numbers_for_cars_with_colour',
  'slot_numbers_for_cars_with_colour',
  'slot_number_for_registration_number',
  'exit'
].freeze

def init_apps
  @exit_loop    = false
  @parking_lot  = 0
  @parking_list = {}
  @cars         = []
end

# assuming everytime parking lot created, existing parking_list would reinitialized
def initialize_parking_list(max_slot)
  @parking_lot = max_slot.to_i
  @parking_list = {}

  @parking_lot.times.each do |index|
    @parking_list[index + 1] = ParkingList.new(
      registration_number: nil,
      colour: nil,
      status: 'free'
    )
  end

  puts "Created a parking lot with #{@parking_lot} slots\n"
end

def park_a_car(registration_number:, colour:)
  parked = false

  @parking_list.each do |slot_number, parking_entry|
    next if parking_entry.status != 'free'

    @parking_list[slot_number].registration_number = registration_number
    @parking_list[slot_number].colour = colour
    @parking_list[slot_number].status = 'full'
    parked = true

    puts "Allocated slot number: #{slot_number}\n"
    break
  end

  puts "Sorry, parking lot is full\n" unless parked
end

def empty_a_slot(slot_number:)
  slot_number = slot_number.to_i

  unless @parking_list[slot_number].nil?
    @parking_list[slot_number].registration_number = nil
    @parking_list[slot_number].colour = nil
    @parking_list[slot_number].status = 'free'
  end
  puts "Slot number #{slot_number} is free\n"
end

def show_parking_list
  puts "Slot No.    Registration No    Colour"
  @parking_list.each do |slot_number, parking_entry|
    if parking_entry.status == 'full'
      puts "#{slot_number}           #{parking_entry.registration_number}      #{parking_entry.colour}"
    end
  end
end

def find_registration_number_by_colour(colour:)
  numbers = []
  @parking_list.each do |slot_number, parking_entry|
    numbers << parking_entry.registration_number if parking_entry.colour == colour
  end
  messages = numbers.any? ? numbers.join(', ') : "Not found"
  puts "#{messages}\n"
end

def find_slot_number_by_colour(colour:)
  numbers = []
  @parking_list.each do |slot_number, parking_entry|
    numbers << slot_number if parking_entry.colour == colour
  end
  messages = numbers.any? ? numbers.join(', ') : "Not found"
  puts "#{messages}\n"
end

def find_slot_number_by_registration_number(registration_number:)
  numbers = []
  @parking_list.each do |slot_number, parking_entry|
    numbers << slot_number if parking_entry.registration_number == registration_number
  end
  messages = numbers.any? ? numbers.join(', ') : "Not found\n"
  puts "#{messages}"
end


# This is part of code which run the apps

init_apps

loop do
  begin
    user_input = gets.chomp
    user_inputs = user_input.split(' ')

    command = user_inputs[0]
    first_attributes  = user_inputs[1] if user_inputs.count > 1
    second_attributes = user_inputs[2] if user_inputs.count > 2

    if !VALID_INPUT.include? command
      puts "Invalid input\n"
    elsif command == 'create_parking_lot'
      initialize_parking_list(first_attributes)
    elsif command == 'park'
      park_a_car(registration_number: first_attributes, colour: second_attributes)
    elsif command == 'leave'
      empty_a_slot(slot_number: first_attributes)
    elsif command == 'status'
      show_parking_list
    elsif command == 'registration_numbers_for_cars_with_colour'
      find_registration_number_by_colour(colour: first_attributes)
    elsif command == 'slot_numbers_for_cars_with_colour'
      find_slot_number_by_colour(colour: first_attributes)
    elsif command == 'slot_number_for_registration_number'
      find_slot_number_by_registration_number(registration_number: first_attributes)
    elsif user_input == 'exit'
      @exit_loop = true
    end
    break if @exit_loop
  rescue
    break
  end
end
