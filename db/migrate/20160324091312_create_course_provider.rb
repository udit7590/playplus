class CreateCourseProvider < ActiveRecord::Migration
  def change
    create_table :course_providers do |t|
      t.references :course, index: true

      t.string     :firstname
      t.string     :lastname
      t.string     :address1
      t.string     :address2
      t.string     :zipcode
      t.string     :phone
      t.string     :alternative_phone
      t.string     :company
      t.string     :locality
      t.string     :nearby
      t.string     :city
      t.string     :state
      t.string     :country

      t.string     :company_image_hashed_id
      t.string     :location_image_hashed_id

      t.boolean    :active

      t.timestamps
    end
  end
end
