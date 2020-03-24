# -------------------- @properties     --------------------
# references :course, index: true
# string     :firstname
# string     :lastname
# string     :address1
# string     :address2
# string     :zipcode
# string     :phone
# string     :alternative_phone
# string     :company
# string     :locality
# string     :nearby
# string     :city
# string     :state
# string     :country
# string     :company_image_hashed_id
# string     :location_image_hashed_id
# boolean    :active
# -------------------- @properties_end --------------------

# -------------------- @notes --------------------
# Initially, only area, city and state is displayed to user so that he can find a course
# DO NOT LEAK provider info on the website
# ----------------------------------------------------------------------------------------------------
class CourseProvider < ActiveRecord::Base
  has_many :course_levels, dependent: :destroy
  belongs_to :course
  accepts_nested_attributes_for :course_levels, allow_destroy: true

  validates_presence_of :company, :locality, :city, :state, :country, :zipcode, :address1
  # TODO: Allow only specific states and countries

  scope :active, -> { where(active: true) }

  def complete_address
    company.to_s + "\n" + address1.to_s + "\n" + address2.to_s + "\n" + city.to_s + "," + state.to_s
  end
end
