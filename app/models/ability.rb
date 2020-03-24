class Ability
  include CanCan::Ability

  def initialize(user)
    # For guest user
  end

  def self.for_user(user)
    if user.blank? || user.new_record?
      new(user || User.new)
    else
      "#{user.role}_ability".classify.constantize.new(user)
    end
  end
end
