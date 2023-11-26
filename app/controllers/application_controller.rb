class ApplicationController < ActionController::API
  include HasPagination
  include HasSerialization
  include HasResponseRendering

  before_action :authenticate_user

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def authenticate_user
    token = request.headers['Authorization']
    return render_unauthorized unless token

    token = token.split(' ')&.last
    user_payload = Jwt.decode(token)
    return render_unauthorized unless user_payload

    @current_user = User.find_by(id: user_payload['id'])

    render json: { error: 'User not found' }, status: :unauthorized unless @current_user
  end

  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def render_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
end
