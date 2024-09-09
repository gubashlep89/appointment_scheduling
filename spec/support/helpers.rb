module Helpers
  def sign_in(doctor = nil)
    return unless doctor

    post doctor_session_path, params: {
      'user[email]' => doctor.email,
      'user[password]' => doctor.password
    }
  end
end
