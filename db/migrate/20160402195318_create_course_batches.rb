class CreateCourseBatches < ActiveRecord::Migration
  def change
    create_table :course_batches do |t|
      t.references :course_level, index: true

      t.integer :capacity
      t.string :description
      t.string :instructor
      t.integer :duration # In hours
      
      t.string :type # Fixed, variable
      
      # For fixed batches. In this case, has_one is required
      t.integer :frequency # Annually, bi-annually, quarterly, monthly, weekly, daily
      t.integer :start_day # For monthly
      t.integer :start_month # For quarterly/annually
      t.integer :start_week # For weekly

      # For variable batches
      t.datetime :start_date
      t.datetime :end_date

      # Timings
      t.time :start_time1
      t.time :start_time2
      t.time :start_time3
      t.time :end_time1
      t.time :end_time2
      t.time :end_time3

      t.timestamps
    end
  end
end
