class AdminMailer < ApplicationMailer

  default from: 'enquiries@zuluplus.com'
  layout 'email/standard_admin_mailer'

  def customer_enquiry(admin_ids, user_name, user_email, enquiry)
    @user_name  = user_name
    @user_email = user_email
    @enquiry    = enquiry
    @admins     = User.where(id: admin_ids)
    return nil unless @admins.present?

    mail(to: @admins.pluck(:email), subject: '[ZuluPlus] We have received a new enquiry from a customer')
  end

end
