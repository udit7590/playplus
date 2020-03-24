class CreateCourseLevels < ActiveRecord::Migration
  def change
    create_table :course_levels do |t|
      t.references :course_provider, index: true
      t.integer :capacity
      t.integer :level
      t.string :level_name
      t.decimal :price, precision: 12, scale: 2 # In rupees

      t.string :image_hashed_id

      t.string :coach_name
      t.string :description
      t.string :instructions
      t.string :prerequisites
      t.string :inclusions
      t.integer :duration # In hours
      t.integer :sessions # In number
      t.integer :session_duration # In minutes

      t.boolean :has_batches
      t.boolean :active
      t.timestamps
    end
  end
end
