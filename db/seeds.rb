# Create doctors
emails = %w[doctor@example.com doctor1@example.com]
emails.each do |email|
  doctor = Doctor.find_or_initialize_by(email: email)
  next unless doctor.new_record?

  doctor.password = 'changeme'
  doctor.name = Faker::Name.name
  doctor.save!
end

# Create patient
patient = Patient.find_or_initialize_by(name: 'John Doe', contact_details: '+123321123')
patient.save!

# Make an appointment for first patient with first doctor
appointment = Appointment.find_or_initialize_by(started_at: "#{Date.current} 08:00", patient: patient, doctor: Doctor.first)
appointment.save!

puts 'Seeds added successfully!'
