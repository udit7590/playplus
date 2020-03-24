module PermittedAttributes
  ATTRIBUTES = [
    :user_attributes,
    :address_attributes,
    :course_attributes,
    :course_batch_attributes,
    :course_level_attributes,
    :course_provider_attributes,
    :enrollment_attributes
  ]

  mattr_reader *ATTRIBUTES

  @@user_attributes = [
    :first_name, :last_name, :phone_number
  ]

  @@address_attributes = [
    :id, :firstname, :lastname, :first_name, :last_name,
    :address1, :address2, :city, :country, :state,
    :zipcode, :phone, :alternative_phone, :company
  ]

  @@course_attributes = [
    :name, :description, :main_image_hashed_id, :tag_list, :instructions, :prerequisites, :inclusions
  ]

  @@course_batch_attributes = [
    :capacity, :description, :instructor,
    :duration, :type, :frequency, :id, :_destroy,
    :start_day, :start_month, :start_week, :start_date, :end_date,
    :start_time1, :start_time2, :start_time3,
    :end_time1, :end_time2, :end_time3
  ]

  @@course_level_attributes = [
    :capacity, :level, :price, :coach_name, :description, :instructions,
    :prerequisites, :inclusions, :duration, :id, :_destroy,
    :sessions, :session_duration, :image_hashed_id, :level_name,
    :has_batches, :active
  ]

  @@course_provider_attributes = [
    :id, :firstname, :lastname, :first_name, :last_name,
    :address1, :address2, :city, :country, :state, :nearby,
    :zipcode, :phone, :alternative_phone, :company, :locality, :active,
    :_destroy, :company_image_hashed_id, :location_image_hashed_id
  ]

  @@enrollment_attributes = [
    :id, :start_date, :end_date, :email, :phone,
    :course_level_id, :course_batch_id, :course_provider_id, :course_level, :course_batch
  ]

end
