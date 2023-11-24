class SessionsController < ApiController
  def initiate_google_oauth2
    render json: { redirect: google_auth_service.initiate_oauth2 }
  end

  def google_oauth2_callback
    user_info = google_auth_service.handle_callback(params)
    render json: { user: user_info }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def google_auth_service
    @google_auth_service ||= GoogleAuthService.new
  end
end
