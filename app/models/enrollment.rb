# -------------------- @properties     --------------------
# references       :course_level, index: true
# references       :course_batch, index: true
# references       :user, index: true

# datetime         :start_date # In case no batches
# datetime         :end_date # In case no batches
# string           :last_ip_address
# string           :email
# string           :phone
# references       :billing_address_id
# string           :currency
# decimal          :actual_amount # Taxes + processing fees + course fee
# decimal          :adjusted_amount # Discount
# decimal          :final_amount # Final bill amount
# integer          :state # checkout, enquiry, address, payment, enrolled, started, finished, cancelled, dropped
# -------------------- @properties_end --------------------

# -------------------- @notes --------------------
# Requires start date, course location, level and the batch
# ------------------------------------------------------------
class Enrollment < ActiveRecord::Base
  attr_accessor :course_provider_id
  belongs_to :course_level
  belongs_to :course_batch
  belongs_to :user
  # TODO: Add reference to course_provider and course as well

  # TODO: Calculate taxes and amount on before_create

  # ---------------------------------------------------------------------------------------------------------
  # STATE MACHINE SECTION
  # ---------------------------------------------------------------------------------------------------------
  # ISSUE FIX: state is not initialized.
  before_validation :set_initial_state, if: -> { state.blank? }

  state_machine initial: :checkout do

    # STATE DECLARATIONS
    state :checkout,    value: 0
    state :enquired,    value: 1
    state :address,     value: 2
    state :payment,     value: 3
    state :enrolled,    value: 4
    state :started,     value: 5
    state :finished,    value: 6
    state :cancelled,   value: 7
    state :dropped,     value: 8

    # EVENT DECLARATIONS
    event :enquire do
      transition [:checkout, :address] => :enquired
    end

    event :cancel do
      transition [:enquired, :payment, :address, :checkout] =>  :cancelled
    end

    event :enroll do
      transition [:enquired, :payment, :address] =>  :enrolled
    end

    event :start_course do
      transition [:enrolled] =>  :started
    end

    event :finish_course do
      transition [:started] =>  :finished
    end

    event :drop_course do
      transition [:started] =>  :dropped
    end

    # PRE-TRANSITION PROCESSING
    # before_transition on: :publish,      do: :pre_publish_validations

  end

  def self.state_descriptions
    {
      checkout: 'Initiated a request for enrollment',
      enquired: 'Requested for enrollment',
      address: 'Need address information to enroll',
      payment: 'Need to complete payment to enroll',
      started: 'Enrollment is confirmed and the course has started',
      finished: 'Course has ended',
      cancelled: 'Enrollment is cancelled due to some reason. Eg. Payment failure',
      dropped: 'User has dropped out of the course'
    }
  end

  # ---------------------------------------------------------------------------------------------------------
  # INSTANCE METHODS SECTION
  # ---------------------------------------------------------------------------------------------------------

  def course
    course_batch.course_level.course_provider.course
  end

  def provider_complete_address
    provider = course_batch.course_level.course_provider
    if state.in?([0,1,2,3])
     "#{ provider.city.to_s + ', ' + provider.state.to_s }. Please confirm your enrollment to get further location and contact details"
    else
      provider.company.to_s + "\n" + provider.address1.to_s + "\n" + provider.address2.to_s + "\n" + provider.city.to_s + ", " + provider.state.to_s
    end
  end

  private
    def set_initial_state
      self.state = 0
    end
end
