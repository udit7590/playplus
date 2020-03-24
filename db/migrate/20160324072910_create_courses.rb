class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.text :description
      t.string :instructions
      t.string :prerequisites
      t.string :inclusions

      t.string :tags
      t.references :category, index: true

      t.string :main_image_hashed_id

      # t.boolean :master

      # t.string :state # Acts as cache for course location
      # t.string :city  # Acts as cache for course location
      t.timestamps
    end
  end
end
