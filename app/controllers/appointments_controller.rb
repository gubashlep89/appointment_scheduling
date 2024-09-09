class AppointmentsController < ApplicationController
  before_action :set_doctor, only: %i[ new index ]
  before_action :set_date, only: :index

  # GET /appointments or /appointments.json
  def index
    # where("repeated == 1 AND strftime('%w', started_at) == strftime('%w', '#{date}') AND started_at <= '#{date}' OR repeated == 1 AND repeated_end >= '#{date}' AND strftime('%w', started_at) == strftime('%w', '#{date}') AND started_at <= '#{date}'")
    @appointments = @doctor.appointments
                           .today(@date)
                           .or(@doctor.appointments.bocked_earlier(@date))
                           .or(@doctor.appointments.bocked_earlier_with_end_date(@date))
  end

  # GET /appointments/new
  def new
    @appointment = @doctor.appointments.new(started_at: params[:started_at])
  end

  # POST /appointments or /appointments.json
  def create
    result = AppointmentBuilderService.call(appointment_params.merge({doctor_id: params[:doctor_id]}))

    if result.is_a?(Appointment)
      redirect_to doctor_appointments_path(result.doctor)
    else
      redirect_to new_doctor_appointment_path(doctor_id: result[:doctor_id], started_at: result[:started_at]), alert: result[:message]
    end
  end

  private
  def set_doctor
    @doctor = Doctor.find(params[:doctor_id])
  end

  def set_date
    Date.parse(params[:date])
    @date = params[:date]
  rescue
    @date = Date.current.strftime('%d-%m-%Y')
  end

  # Only allow a list of trusted parameters through.
  def appointment_params
    params.require(:appointment).permit(:started_at, :doctor_id, :repeated, :repeated_end,  :name, :contact_details)
  end
end
