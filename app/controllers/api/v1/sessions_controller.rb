class Api::V1::SessionsController < Devise::SessionsController
  include RackSessionsFix
  include ActionController::Cookies # Added to include cookies support

  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    token = Warden::JWTAuth::UserEncoder.new.call(current_user, :user, nil).first
    decoded_token = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!, true, algorithm: 'HS256').first
    expiration_time = Time.at(decoded_token['exp'])
    Rails.logger.info "Token created for user ##{current_user.id} with expiration at: #{expiration_time}"
    Rails.logger.info "Token: #{token}"

    cookies.signed[:jwt] = { value: token, httponly: true, secure: Rails.env.production? }
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
    token_expired = false

    if token.present?
      begin
        jwt_payload = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!, true, algorithm: 'HS256').first
        expiration_time = Time.at(jwt_payload['exp'])
        Rails.logger.info "Token being decoded with expiration at: #{expiration_time}"
        current_user = User.find_by(id: jwt_payload['sub'], jti: jwt_payload['jti'])
      rescue JWT::ExpiredSignature
        decoded_token = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!, false) # Decode without verification
        user_id = decoded_token[0]['sub'] # Assuming 'sub' is where you store the user ID
        expiration_time = Time.at(decoded_token[0]['exp'])
        Rails.logger.info "Expired token decoded with expiration at: #{expiration_time}"
        current_user = User.find_by(id: user_id)
        token_expired = true
        Rails.logger.info "Token expired but proceeding with logout for user ##{user_id}"
      rescue JWT::DecodeError => e
        render json: { status: 401, message: "Invalid token: #{e.message}" }, status: :unauthorized
        return
      end
    end

    if current_user
      sign_out current_user # Ensure you are using Devise's sign_out method appropriately
      message = token_expired ? 'Token expired, but logged out successfully.' : 'Logged out successfully.'
      render json: {
        status: 200,
        message: message
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
