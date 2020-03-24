class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.references :user, index: true
      t.references :course_level, index: true

      t.references :course_batch, index: true
      t.datetime :start_date # In case no batches
      t.datetime :end_date # In case no batches

      t.string :last_ip_address
      t.string :email
      t.string :phone
      t.references :billing_address_id
      
      t.string :currency
      t.decimal :actual_amount # Taxes + processing fees + course fee
      t.decimal :adjusted_amount # Discount
      t.decimal :final_amount # Final bill amount

      t.integer :state # Enquiry, checkout, payment, enrolled, started, finished, cancelled, dropped
      t.timestamps
    end
  end
end
