
class User < ActiveRecord::Base
  enum role: { member: 0, admin: 1 }

  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  scope :admins, -> { where(role: roles[:admin]) }
  has_one :newsletter, dependent: :destroy
  has_many :enrollments, dependent: :destroy

  def name
    first_name.to_s + ' ' + last_name.to_s
  end

  def self.admin_ids
    admins.pluck(:id)
  end

  def subscribed_to_newsletter?
    !!newsletter
  end
end
