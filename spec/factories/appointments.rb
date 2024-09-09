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
FactoryBot.define do
  factory :appointment do
    association :patient, factory: :patient

    trait :monday_08_00_single do
      started_at { DateTime.parse('02-09-2024 08:00') }
    end

    trait :monday_08_00_multiple do
      started_at { DateTime.parse('30-09-2024 08:00') }
      repeated { true }
    end

    trait :monday_08_00_multiple_2_times do
      started_at { DateTime.parse('02-09-2024 08:00') }
      repeated { true }
      repeated_end { DateTime.parse('09-09-2024 23:59') }
    end
  end
end
