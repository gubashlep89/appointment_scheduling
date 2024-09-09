class AppointmentBuilderService
  def self.call(params)
    appointment = Appointment.new(params.slice('started_at', 'repeated', 'doctor_id'))
    patient = Patient.new(params.slice('name', 'contact_details'))
    ActiveRecord::Base.transaction do
      patient.save!
      appointment.patient = patient
      appointment.repeated_end = params['repeated_end'] if params['repeated_end'].present?
      appointment.save!
    end
    appointment
  rescue ActiveRecord::RecordInvalid => e
    { message: e.message, doctor_id: params[:doctor_id], started_at: params[:started_at] }
  end
end
