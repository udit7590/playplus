class AdminAbility < Ability
  def initialize(user)
    can :manage, :all
    super
  end
end
