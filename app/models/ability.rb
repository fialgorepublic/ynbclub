class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.is_admin?
      can :manage, :all
    elsif user.is_ambassador?
      # can :read, :all
      can :manage, [Blog, ReferralSale]
    end
  end
end
