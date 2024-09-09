# == Schema Information
#
# Table name: appointments
#
#  id           :integer          not null, primary key
#  started_at   :datetime
#  repeated     :boolean
#  repeated_end :datetime
#  patient_id   :integer          not null
#  doctor_id    :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Appointment, type: :model do
  let(:doctor) { FactoryBot.create(:doctor) }
  let(:patient) { FactoryBot.create(:patient) }

  it 'is valid with basic attributes' do
    expect(Appointment.new(started_at: '02-09-2024 08:00', doctor:, patient:)).to be_valid
  end

  it 'is valid with repeated flag' do
    expect(Appointment.new(started_at: '02-09-2024 08:00', repeated: true, doctor:, patient:)).to be_valid
  end

  it 'is valid with repeated flag and repeated_end date' do
    expect(Appointment.new(started_at: '02-09-2024 08:00',
                           repeated: true,
                           repeated_end: '09-09-2024 08:00',
                           doctor:,
                           patient:)).to be_valid
  end

  it 'is not valid without a doctor' do
    expect(Appointment.new(started_at: '02-09-2024 08:00', patient:)).not_to be_valid
  end

  it 'is not valid without a patient' do
    expect(Appointment.new(started_at: '02-09-2024 08:00', doctor:)).not_to be_valid
  end

  context 'when Monday 08:00 taken' do
    before :each do
      FactoryBot.create(:appointment, :monday_08_00_single, doctor:)
    end

    it 'is not valid timeslot already taken' do
      expect(Appointment.new(started_at: '02-09-2024 08:00', doctor:, patient:)).not_to be_valid
    end

    it 'valid next hour' do
      expect(Appointment.new(started_at: '02-09-2024 09:00', doctor:, patient:)).to be_valid
    end
  end

  context 'when window between 02.09..09.09 -> 30.09..' do
    before :each do
      FactoryBot.create(:appointment, :monday_08_00_multiple, doctor:)
      FactoryBot.create(:appointment, :monday_08_00_multiple_2_times, doctor:)
    end

    it 'is not valid timeslot already taken' do
      expect(Appointment.new(started_at: '02-09-2024 08:00', doctor:, patient:)).not_to be_valid
    end

    it 'valid next week' do
      expect(Appointment.new(started_at: '16-09-2024 08:00', doctor:, patient:)).to be_valid
    end

    it 'valid next week two times' do
      expect(Appointment.new(started_at: '16-09-2024 08:00',
                             repeated_end: '23-09-2024 23:59',
                             repeated: true,
                             doctor:,
                             patient:)).to be_valid
    end

    it 'is not valid next week without repeated_end' do
      expect(Appointment.new(started_at: '16-09-2024 08:00', repeated: true , doctor:, patient:)).not_to be_valid
    end

    it 'is not valid next week with repeated_end' do
      expect(Appointment.new(started_at: '16-09-2024 08:00',
                             repeated_end: '30-09-2024 23:59',
                             repeated: true,
                             doctor:,
                             patient:)).not_to be_valid
    end

    it 'is not valid timeslot already taken by repeated ended at 09-10' do
      expect(Appointment.new(started_at: '09-09-2024 08:00', doctor:, patient:)).not_to be_valid
    end

    it 'is not valid timeslot already taken by repeated' do
      expect(Appointment.new(started_at: '07-10-2024 08:00', doctor:, patient:)).not_to be_valid
    end
  end
end
