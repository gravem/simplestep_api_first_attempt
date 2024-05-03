class Api::V1::SessionsController < Devise::SessionsController
  include RackSessionsFix

  respond_to :json
  private
  def respond_with(current_user, _opts = {})
    render json: {
      status: {
        code: 200, message: 'Logged in successfully.',
        data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
      }
    }, status: :ok
  end
  def respond_to_on_destroy
    current_user = nil
    token = request.headers['Authorization'].to_s.split(' ').last

    if token.present?
      begin
        jwt_payload = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!, true, algorithm: 'HS256').first
        current_user = User.find_by(id: jwt_payload['sub'], jti: jwt_payload['jti'])
      rescue JWT::ExpiredSignature
        # If the token is expired, you might still want to find the user from the token and log them out
        decoded_token = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!, false) # Decode without verification
        user_id = decoded_token[0]['sub'] # Assuming 'sub' is where you store the user ID
        current_user = User.find_by(id: user_id)
        # Log that the token was expired but still processing logout
        Rails.logger.info "Token expired but proceeding with logout for user ##{user_id}"
      rescue JWT::DecodeError => e
        render json: { status: 401, message: "Invalid token: #{e.message}" }, status: :unauthorized
        return
      end
    end

    if current_user
      sign_out current_user # Ensure you are using Devise's sign_out method appropriately
      render json: {
        status: 200,
        message: 'Logged out successfully.'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
