class CreateNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|
      t.string :email
      t.references :user, index: true
      t.string :medium # `website` for web newsletter subscription
      t.datetime :unsubscribed_at
      t.timestamps
    end
  end
end
