# -------------------- @properties     --------------------
# references       :course_provider, index: true
# integer          :capacity
# integer          :level
# string           :level_name
# decimal          :price, precision: 12, scale: 2 # In rupees
# string           :image_hashed_id
# string           :coach_name
# string           :description
# string           :instructions
# string           :prerequisites
# string           :inclusions
# integer          :duration # In hours
# integer          :sessions # In number
# integer          :session_duration # In minutes
# boolean          :has_batches
# boolean          :active
# -------------------- @properties_end --------------------

class CourseLevel < ActiveRecord::Base
  belongs_to :course_provider
  has_many :course_batches, dependent: :destroy
  accepts_nested_attributes_for :course_batches, allow_destroy: true

  scope :active, -> { where(active: true) }

  # TODO_IMP: Prevent delete if it has active enrollments

  def price_display
    'INR ' + price.to_s
  end

  def taxes
    price * 0.2
  end

  def taxes_display
    'INR ' + taxes.to_s
  end

  def net_amount
    (price + taxes)
  end

  def net_amount_display
    'INR ' + (price + taxes).to_s
  end

  def all_levels
    course_provider.course_levels.pluck(:level_name)
  end

  def further_levels
    fl = course_provider.course_levels.pluck(:level_name, :level).select { |ld| ld[1] > level }.map { |ld| ld[0] }
    fl.presence || ['None']
  end
end
