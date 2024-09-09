class PatientsController < ApplicationController
  before_action :authenticate_doctor!
  before_action :set_patient, only: %i[show edit update]

  # GET /patients
  def index
    @patients = Patient.all
  end

  # GET /patients/1
  def show; end

  # GET /patients/1/edit
  def edit; end

  # PATCH/PUT /patients/1 or /patients/1.json
  def update
    if @patient.update(patient_params)
      redirect_to patient_url(@patient), notice: 'Patient was successfully updated.'
    else
      flash.now[:alert] = @patient.errors.messages.map{|attribute, message| "#{attribute.capitalize}: #{message.join(', ')}"}.join(', ')
      render :edit, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def patient_params
      params.require(:patient).permit(:name, :contact_details, :history_summary)
    end
end
