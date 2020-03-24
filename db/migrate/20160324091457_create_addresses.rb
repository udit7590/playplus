class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string     :firstname
      t.string     :lastname
      t.string     :address1
      t.string     :address2
      t.string     :city
      t.string     :zipcode
      t.string     :phone
      t.string     :alternative_phone
      t.string     :company
      t.string     :state
      t.string     :country
      t.timestamps null: false
    end
  end
end
