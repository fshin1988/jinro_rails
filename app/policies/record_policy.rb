class RecordPolicy < ApplicationPolicy
  def vote?
    valid_player?
  end

  def attack?
    return false unless valid_player?
    if record.village.player_from_user(user).werewolf? && record.village.attack_on_today?
      true
    else
      false
    end
  end

  def divine?
    return false unless valid_player?
    if record.village.player_from_user(user).fortune_teller?
      true
    else
      false
    end
  end

  def guard?
    return false unless valid_player?
    if record.village.player_from_user(user).bodyguard?
      true
    else
      false
    end
  end

  private

  def valid_player?
    return false unless record.village.in_play?
    if record.player_id == record.village.player_from_user(user).id && record.village.player_from_user(user).alive?
      true
    else
      false
    end
  end
end
