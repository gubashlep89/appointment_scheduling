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
class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient

  scope :today, ->(date) { where(started_at: date..(DateTime.parse(date).end_of_day)) }
  scope :repeated_same_day_of_week, ->(date) { where("repeated == 1 AND strftime('%w', started_at) == strftime('%w', '#{date}') AND started_at <= '#{date}'") }
  scope :bocked_earlier, ->(date) { repeated_same_day_of_week(date).where("started_at <= '#{date}' AND repeated_end IS NULL") }
  scope :bocked_earlier_with_end_date, ->(date) { repeated_same_day_of_week(date).where("started_at <= '#{date}' AND repeated_end >= '#{date}'") }
  scope :same_day_of_week_and_time, ->(date_time) { where("strftime('%w %H %M', started_at) == ?", date_time) }

  validate :check_existing_appointments

  def check_existing_appointments
    # check if same timeslot taken
    if Appointment.where(started_at: started_at, doctor: doctor).any?
      errors.add(:started_at, 'timeslot already taken')
    end

    # check if same timeslot was taken by repeated appointment without repeated_end
    if Appointment.same_day_of_week_and_time(started_at.strftime('%w %H %M')).where(doctor: doctor, repeated: true, repeated_end: nil).where("started_at <= ?", started_at).any?
      errors.add(:started_at, 'timeslot already taken')
    end

    # check if same timeslot was taken by repeated appointment
    if Appointment.same_day_of_week_and_time(started_at.strftime('%w %H %M')).where(doctor: doctor, repeated: true).where("started_at <= ? AND repeated_end >= ?", started_at, started_at).any?
      errors.add(:started_at, 'timeslot already taken')
    end
    return unless repeated

    if repeated_end
      # check if same timeslot was taken in future and overlapped with interval from started_at to repeated_end
      if Appointment.same_day_of_week_and_time(started_at.strftime('%w %H %M')).where(doctor: doctor).where("started_at <= ? AND started_at >= ?", repeated_end.end_of_day, started_at).any?
        errors.add(:repeated_end, 'timeslot already taken in future appointments')
      end
    else
      # check if same timeslot was taken in future
      if Appointment.same_day_of_week_and_time(started_at.strftime('%w %H %M')).where(doctor: doctor).where("started_at >= ?", started_at).any?
        errors.add(:repeated, 'her')
      end
    end
  end
end
