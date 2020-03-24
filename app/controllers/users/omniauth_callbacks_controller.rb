class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :check_for_fb_permissions, only: :facebook
  before_action :load_identity, only: [:facebook, :instagram]
  before_action :check_if_identity_belongs_to_other, only: [:facebook, :instagram]

  def facebook
    generic_callback('facebook')
  end

  def facebook_rerequest
    redirect_to user_omniauth_authorize_path('facebook', auth_type: 'rerequest', scope: FACEBOOK_CONFIG[:scope])
  end

  def instagram
    generic_callback('instagram')
  end

  private

    # -------------------------------------------------------------------------------------------------------
    # This method is a generic method which is invoked with appropriate provider as an argument.
    # If user already exist in the system:
    # - sign it in and redirect to the url specified by after_sign_in_path_for.
    # - set appropriate flash message
    #
    # Otherwise:
    # - set session["devise.oauth_attributes"] with omniauth data
    # - set session["devise.identity_id"] with identity id
    # - redirect to signup page.
    # -------------------------------------------------------------------------------------------------------
    def generic_callback(provider)
      @user = @identity.user || current_user

      if @user && @user.persisted?
        @identity.update_attribute( :user_id, @user.id ) unless @identity.user_id
        if current_user
          flash[:notice] = t('flash.notice.profile_linked', provider: env["omniauth.auth"].provider)
          redirect_to profile_settings_user_path(current_user)
        else
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
        end
      else
        session["devise.oauth_attributes"] = env["omniauth.auth"]
        session["devise.identity_id"]      = @identity.id
        redirect_to new_user_registration_url
      end
    end

    # -------------------------------------------------------------------------------------------------------
    # This method checks the status of the returned permissions.
    # If any of the requested permissions isn't granted, then:
    # - set appropriate error message.
    # - set insufficient_permissions in flash to true
    # - redirect the user to path returned from facebook_logout_and_redirect_url
    # -------------------------------------------------------------------------------------------------------
    def check_for_fb_permissions
      permissions_array = Koala::Facebook::API.new(env["omniauth.auth"].credentials.token, FACEBOOK_CONFIG[:app_secret])
                                              .get_connections('me','permissions')

      unless permissions_array && permissions_array.all? { |permission| permission['status'] == 'granted' }
        flash[:alert] = t('flash.alert.facebook_insufficient_permissions')
        flash[:insufficient_permissions] = true
        redirect_to facebook_logout_and_redirect_url
      end
    end

    # -------------------------------------------------------------------------------------------------------
    # This method loads the identity based on the env["omniauth.auth"]
    # If a valid identity is not persisted in the database, then:
    # - set appropriate flash alert
    # - redirect user to signup page
    # -------------------------------------------------------------------------------------------------------
    def load_identity
      @identity = Identity.find_for_oauth env["omniauth.auth"]

      unless @identity && @identity.valid?
        flash[:alert] = t('flash.alert.bad_data_return', provider: env["omniauth.auth"].provider)
        redirect_to new_user_registration_url
      end
    end

    # -------------------------------------------------------------------------------------------------------
    # This method returns the path to logout from facebook and redirect back to signup page
    # -------------------------------------------------------------------------------------------------------
    def facebook_logout_and_redirect_url
      redirect_path       = if current_user
                              profile_settings_user_url(current_user)
                            else
                              new_user_registration_url
                            end
      access_token        = env["omniauth.auth"].credentials.token
      "#{ FACEBOOK_CONFIG[:logout_url] }?next=#{ redirect_path }&access_token=#{ access_token }"
    end

    def after_omniauth_failure_path_for(scope)
      if current_user
        profile_settings_user_url(current_user)
      else
        new_registration_path(scope)
      end
    end

    def check_if_identity_belongs_to_other
      if @identity.user && current_user && (@identity.user != current_user)
        flash[:alert] = t('flash.alert.already_exists', provider: env["omniauth.auth"].provider)
        redirect_to profile_settings_user_path(current_user)
      end
    end

end
