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
class Patient < ApplicationRecord
  has_many :appointments, dependent: :destroy

  validates :name, length: { minimum: 2, maximum: 50 }, allow_blank: false
  validates :contact_details, length: { minimum: 4, maximum: 50 }, allow_blank: false
end
