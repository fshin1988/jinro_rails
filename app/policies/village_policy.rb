class VillagePolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    return false unless user
    true
  end

  def new?
    create?
  end

  def update?
    return false unless user
    return false unless record.not_started?
    if user.admin?
      true
    else
      record.user_id == user.id
    end
  end

  def edit?
    update?
  end

  def destroy?
    return false unless user
    return false unless record.not_started?
    if user.admin?
      true
    else
      record.user_id == user.id
    end
  end

  def join?
    return false unless user
    if record.status == 'not_started' && record.player_from_user(user).nil? && record.players.count < record.player_num
      true
    else
      false
    end
  end

  def exit?
    return false unless user
    if record.status == 'not_started' && record.player_from_user(user).present?
      true
    else
      false
    end
  end

  def start?
    return false unless user
    if record.user_id == user.id && record.players.count == record.player_num && record.status == 'not_started'
      true
    else
      false
    end
  end

  def remaining_time?
    true
  end

  def divine?
    return false unless user
    if record.player_from_user(user)&.fortune_teller? && record.player_from_user(user).alive? && record.day > 1
      true
    else
      false
    end
  end

  def see_soul?
    return false unless user
    if record.player_from_user(user)&.psychic? && record.player_from_user(user).alive? && record.day > 1
      true
    else
      false
    end
  end
end
