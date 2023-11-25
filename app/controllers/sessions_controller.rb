class SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def initiate_google_oauth2
    render json: { redirect: google_auth.initiate_oauth2 }
  end

  def google_oauth2_callback
    user_info = google_auth.handle_callback(params)
    user = Users::CreateFromGoogleAuth.new(user_info).call
    token = Jwt.encode({ id: user.id })

    render json: { token: }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def google_auth
    @google_auth ||= GoogleAuth.new
  end
end
