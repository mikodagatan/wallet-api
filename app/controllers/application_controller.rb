class ApplicationController < ActionController::API
  before_action :authenticate_user

  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    user_payload = JwtService.decode(token)

    if token.blank? || user_payload.blank?
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    end

    @current_user = User.find_by(email: user_payload['email'])

    render json: { error: 'User not found' }, status: :unauthorized unless @current_user
  end
end
