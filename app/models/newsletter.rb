# -------------------- @properties     --------------------
# references :user, index: true
# string     :email
# string     :medium #website, manual
# datetime   :unsubscribed_at
# timestamps
# -------------------- @properties_end --------------------
class Newsletter < ActiveRecord::Base
  belongs_to :user
  validates :email, presence: true, if: -> { user.blank? }

  def subscribed?
    persisted? && !unsubscribed_at
  end
end
