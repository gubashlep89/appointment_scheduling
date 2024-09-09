require 'rails_helper'

RSpec.describe PatientsController, type: :controller do
  describe '#index' do
    let(:patient) { FactoryBot.create(:patient) }

    it 'redirects from patients index if doctor is not logged' do
      get(:index)
      expect(response).to redirect_to(new_doctor_session_path)
    end

    it 'redirects from patients show if doctor is not logged' do
      get(:show, params: { id: patient.id })
      expect(response).to redirect_to(new_doctor_session_path)
    end

    it 'redirects from patients edit if doctor is not logged' do
      get(:edit, params: { id: patient.id })
      expect(response).to redirect_to(new_doctor_session_path)
    end

    it 'redirects from patients update if doctor is not logged' do
      put(:update, params: { id: patient.id })
      expect(response).to redirect_to(new_doctor_session_path)
    end

    context 'logged' do
      let(:doctor) { FactoryBot.create(:doctor) }
      before(:each) do
        sign_in(doctor)
      end

      it 'renders patients index template' do
        get(:index)
        expect(response).to render_template('index')
      end

      it 'renders patients show' do
        get(:show, params: { id: patient.id })
        expect(response).to render_template('show')
      end

      it 'renders patients edit' do
        get(:edit, params: { id: patient.id })
        expect(response).to render_template('edit')
      end

      it 'renders patients update' do
        put(:update, params: { id: patient.id, patient: { name: patient.name, contact_details: patient.contact_details, history_summary: 'new history summary' } })
        patient.reload

        expect(patient.history_summary).to eq('new history summary')
        expect(response).to redirect_to(patient_path(patient))
      end
    end
  end
end
