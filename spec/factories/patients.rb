# == Schema Information
#
# Table name: patients
#
#  id              :integer          not null, primary key
#  name            :string
#  contact_details :string
#  history_summary :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :patient do
    name { Faker::Name.name }
    contact_details { Faker::PhoneNumber.cell_phone }
  end
end
