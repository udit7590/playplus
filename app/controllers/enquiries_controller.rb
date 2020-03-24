class EnquiriesController < ApplicationController

  def create
    @enquiry = Enquiry.new(enquiry_params)
    if @enquiry.save
      redirect_to contact_path, notice: 'We have received your enquiry. We\'ll get back to you.'
    # else
    #   render js: 'alert("Unable to receive your enquiry. Please ensure all fields are filled.")'
    end
  end

  private
    def enquiry_params
      if current_user.blank?
        params.require(:enquiry).permit(:about, :message, :from_name, :from_email, :from_phone)
      else
        params.require(:enquiry).permit(:about, :message).merge(user_id: current_user.id)
      end
    end
end
