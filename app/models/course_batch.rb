# -------------------- @properties     --------------------
# references     :course_level, index: true
# integer        :capacity
# string         :description
# string         :instructor
# integer        :duration # In hours

# string         :type # fixed, variable

# For fixed batches. In this case, has_one is required
# integer        :frequency # Annually, bi-annually, quarterly, monthly, weekly, daily
# integer        :start_day # For monthly
# integer        :start_month # For quarterly/annually
# integer        :start_week # For weekly

# For variable batches
# datetime       :start_date
# datetime       :end_date

# Timings
# time           :start_time1
# time           :start_time2
# time           :start_time3
# time           :end_time1
# time           :end_time2
# time           :end_time3
# -------------------- @properties_end --------------------

class CourseBatch < ActiveRecord::Base
  belongs_to :course_level

  # Set inheritance column to be nil to prevent STI. We have a column `type`
  self.inheritance_column = nil

  scope :future, -> { where(arel_table[:start_date].gt(Date.today)) }

  has_many :enrollments

  # TODO_IMP: Prevent delete if it has active enrollments
  # TODO: Can add calendar year leaves and working days for the firm and can calculate end_date accordingly

  # TODO: Ensure end_date > start_date

  def seats_available?
    (capacity - total_enrollments) > 0
  end

  def total_enrollments
    et = Enrollment.arel_table
    # TODO: lt -> lte, gt -> gte
    enrollments.where(et[:created_at].lt(end_date).and(et[:created_at].gt(start_date))).count
  end

  def expired?
    start_date.beginning_of_day < Date.today.beginning_of_day
  end
end
