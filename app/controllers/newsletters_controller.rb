class NewslettersController < ApplicationController
  before_action :build_newsletter_subscription, only: :create
  before_action :ensure_own_email, only: :create
  before_action :load_newsletter_subscription, only: :destroy
  before_action :ensure_unsubscription_allowed, only: :destroy

  def create
    if @newsletter.subscribed?
      redirect_to request.referrer, alert: 'You are already subscribed to our newsletter.'
    else
      if @newsletter.save
        session[:subscribed_to_newsletter] = true
        redirect_to request.referrer, notice: 'You have been successfully subscribed to our newsletter.'
      else
        redirect_to request.referrer, alert: 'Unable to subscribe you to our newsletter.'
      end
    end
  end

  def destroy
    # Make sure user never see unable to unsubscribe error. Dosent look good.
    @newsletter_subscription.destroy
    redirect_to request.referrer, notice: 'You have been unsubscribed from our newsletters.'
  end

  private
    def build_newsletter_subscription
      if current_user.blank?
        @newsletter = Newsletter.find_or_initialize_by(permitted_newsletter_params)
      else
        @newsletter = Newsletter.find_or_initialize_by(user: current_user, email: current_user.email)
      end
      @newsletter.medium = 'website'
    end

    def permitted_newsletter_params
      params.require(:newsletter).permit(:email)
    end

    def ensure_own_email
      if current_user.blank? && User.find_by(email: @newsletter.email)
        redirect_to request.referrer, alert: 'You need to login with this email to subscribe to our newsletter.'
      end
    end

    def load_newsletter_subscription
      if params[:email].present?
        @newsletter_subscription = Newsletter.find_by(email: params[:email])
      else
        @newsletter_subscription = Newsletter.find_by(id: params[:id])
      end
    end

    def ensure_unsubscription_allowed
      if current_user.blank? || @newsletter_subscription.id != current_user.newsletter.id
        redirect_to root_path, alert: 'Action not allowed'
      end
    end
end
