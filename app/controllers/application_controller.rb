class ApplicationController < ActionController::Base
  include ControllerHelpers::StrongParameters

  layout 'standard'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html do
        flash[:alert] = 'You are not authorized to view this section.'
        redirect_to root_path
      end
      format.json do
        render json: { message: 'You are not authorized to view this section' }, status: 401
      end
      format.js do
        render js: 'console.log("You are not authorized to view this section")', status: 401
      end
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    respond_to do |format|
      format.html do
        flash[:alert] = 'Sorry. The page you are looking for does not exist.'
        redirect_to root_path
      end
    end
  end

  private
    def current_ability
      @current_ability ||= Ability.for_user(current_user)
    end

    def after_sign_in_path_for(resource)
      session.delete(:redirect_url).presence || root_path
    end

    def after_sign_out_path_for(resource)
      root_path
    end

    def facebook_bot?
      logger.tagged("Post View") { logger.info "IP: #{ request.remote_ip } - User-Agent: #{ request.user_agent }" }
      !!(request.user_agent =~ /(facebookexternalhit\/1\.1 | Facebot)/)
    end
end
