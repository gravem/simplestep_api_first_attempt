# The ApplicationController class is the base controller for all other controllers in the application.
# It inherits from ActionController::API, which provides a lightweight controller implementation for APIs.
class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Configures the permitted parameters for user sign up and account update actions.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar])
  end
end
