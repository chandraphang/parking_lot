# parking_lot

This application could received input from files and command.

To use file input, you could run: bin/parking_lot file_inputs.txt

To use command input, you could run: bin/parking_lot

To run test, you could run: bin/run_functional_tests

Here's all command you need to operate the apps:
- create_parking_lot #number
(To create new parking lot)

- park #car_registration_number #car_colour
(To park a car with registration_number and colour)

- leave #slot_number
(To unpark a car by slot_number)

- status
(To display all car in parking slot)

- registration_numbers_for_cars_with_colour #car_colour 
(To find registration_number of cars by it colour)

- slot_numbers_for_cars_with_colour #car_colour
(To find slot_number of cars by it colour)

- slot_number_for_registration_number #car_registration_number
(To find slot_number of cars by it registration_number)

- exit
(To exit app)

For more information, you could read ParkingLot-1.4.2.pdf