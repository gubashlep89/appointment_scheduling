# == Schema Information
#
# Table name: doctors
#
#  id                 :integer          not null, primary key
#  name               :string
#  email              :string           default(""), not null
#  encrypted_password :string           default(""), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :doctor do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'changeme' }
  end
end
