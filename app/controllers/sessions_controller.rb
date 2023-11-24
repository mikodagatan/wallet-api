class SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def initiate_google_oauth2
    render json: { redirect: google_auth_service.initiate_oauth2 }
  end

  def google_oauth2_callback
    user_info = google_auth_service.handle_callback(params)
    user = Users::CreateFromGoogleAuth.new(user_info).call
    token = JwtService.encode({ email: user.email })

    render json: { token: }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def google_auth_service
    @google_auth_service ||= GoogleAuthService.new
  end
end
