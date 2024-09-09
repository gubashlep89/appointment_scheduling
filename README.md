# README

## Requirements
- Ruby 3.1.2
- Rails 7.0.8.4
- Bundler 2.2.3

## How to run
- $bundle install
- $rails db:create
- $rails db:migrate
- $rails db:seed
- $rails s
- go to http://localhost:3000/
- have fun :)

## How to use
- as a patient:
  - go to main page
  - select the doctor
  - find availability in selected date (select another date and push "Select appointment date" button if needed)
  - push "Make appointment" button in the requested time
  - fill the form
  - push "Submit" button
  - when options "Multiple times" and/or "Repeated end" used it will return error if this timeslot already booked in future dates

- as a doctor:
  - push "Login" button
  - fill the form (email: 'doctor@example.com', password: 'changeme')
  - push "Log in" button
  - in "Patients" tab you can see all patients in the system
  - push "Edit patient" button to manage patient record
  - change data in the form and push "Save" button
  - confirm that changes is applied or edit again
  - got to "Patients" tab to see and manage other patients
  - patient functionality also available
  - push "Sign out" to log out the application (doctor functionality available only for logged doctor)

## How to run tests
- $rspec
