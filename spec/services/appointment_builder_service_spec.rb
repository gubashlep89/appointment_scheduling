require 'rails_helper'

describe AppointmentBuilderService do
  describe '#call' do
    let(:doctor_id) { FactoryBot.create(:doctor).id }
    let(:name) { Faker::Name.name }
    let(:repeated) { 0 }
    let(:repeated_end) { '' }
    let(:params) {
      {
        started_at: '02-09-2024 08:00',
        repeated: repeated,
        doctor_id: doctor_id,
        repeated_end: repeated_end,
        name: name,
        contact_details: Faker::PhoneNumber.cell_phone
      }
    }
    let(:result) { AppointmentBuilderService.call(params.stringify_keys) }

    context 'valid params' do
      it 'returns game' do
        expect(result.class).to eq(Appointment)
        expect(result.doctor_id).to eq(doctor_id)
        expect(result.patient.name).to eq(name)
      end
    end

    context 'valid params with repeated end' do
      let(:repeated_end) { '09-09-2024 08:00' }
      let(:repeated) { 1 }
      it 'returns game' do
        expect(result.class).to eq(Appointment)
        expect(result.doctor_id).to eq(doctor_id)
        expect(result.repeated).to be_truthy
        expect(result.repeated_end).to eq(repeated_end)
      end
    end

    context 'name invalid' do
      let(:name) { '' }

      it 'returns error' do
        expect(result.class).to eq(Hash)
        expect(result[:message]).to eq('Validation failed: Name is too short (minimum is 2 characters)')
      end
    end

    context 'doctor is empty' do
      let(:doctor_id) { '' }

      it 'returns error' do
        expect(result.class).to eq(Hash)
        expect(result[:message]).to eq('Validation failed: Doctor must exist')
      end
    end
  end
end
