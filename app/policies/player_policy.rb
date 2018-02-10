class PlayerPolicy < ApplicationPolicy
  def create?
    return false unless user

    village = record.village
    return false if village.blacklist_users.find_by(user: user).present?
    if village.not_started? && village.player_from_user(user).nil? && village.players.count < village.player_num
      true
    else
      false
    end
  end

  def new?
    create?
  end

  def update?
    return false unless user
    return false unless record.village.not_started?
    record.user_id == user.id
  end

  def edit?
    update?
  end

  def edit_avatar?
    update?
  end

  def destroy?
    update?
  end
end
