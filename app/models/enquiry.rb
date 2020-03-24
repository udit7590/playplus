# -------------------- @properties     --------------------
# references :user, index: true
# string     :from_email
# string     :from_name
# string     :from_phone
# string     :about
# text       :message, limit: 4000
# timestamps
# -------------------- @properties_end --------------------
class Enquiry < ActiveRecord::Base
  belongs_to :user

  ABOUT = [
    'Course Availability',
    'New Course',
    'Course Provider',
    'Other'
  ]

  # validates :about, presence: true
  validates :message, presence: true
  validates :from_name, :from_email, presence: true, unless: :user_present?

  after_create :mail_it

  private

    def user_present?
      user.present?
    end

    def user_name
      user.present? ? user.name : from_name
    end

    def user_email
      user.present? ? user.email : from_email
    end

    def mail_message
      " ABOUT: #{ about } \n MESSAGE: #{ message }"
    end

    def mail_it
      AdminMailer.customer_enquiry(User.admin_ids, user_name, user_email, mail_message).deliver
    end
end
