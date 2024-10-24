class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  
  before_action :redirect_to_establishment_registration, if: :user_signed_in?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :surname, :social_security_number, :role_id])
  end

  def redirect_to_establishment_registration
    in_exception_paths = [new_establishment_path, destroy_user_session_path].include?(request.path)

    if current_user.establishment.nil? && !in_exception_paths
      msg = 'Boas vindas! Cadastre seu estabelecimento antes de continuar.'
      redirect_to new_establishment_path, notice: msg
    end
  end


end
