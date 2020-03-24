class CreateEnquiries < ActiveRecord::Migration
  def change
    create_table :enquiries do |t|
      t.references :user
      t.string :from_email
      t.string :from_name
      t.string :from_phone
      t.string :about
      t.text :message, limit: 4000
      t.timestamps
    end
  end
end
