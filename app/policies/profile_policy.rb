class ProfilePolicy < ApplicationPolicy
  def show?
    true
  end

  def update?
    return false unless user
    record.user_id == user.id
  end

  def edit?
    update?
  end
end
