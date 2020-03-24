class Users::SessionsController < Devise::SessionsController
  layout 'standard'
  before_action :store_redirection_url, only: [:new]

  protected
    def store_redirection_url
      (session[:redirect_url] = params[:redirect_url].presence || request.referrer.presence) if !!params[:redirect]
    end
end
