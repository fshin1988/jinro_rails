class RoomPolicy < ApplicationPolicy
  def show?
    if record.for_wolf?
      case record.village.status
      when 'in_play'
        record.village.player_from_user(user)&.werewolf?
      when 'ended'
        true
      else
        false
      end
    else
      true
    end
  end

  def speak?
    if record.for_wolf?
      case record.village.status
      when 'in_play'
        record.village.player_from_user(user)&.werewolf? && record.village.player_from_user(user)&.alive?
      else
        false
      end
    else
      case record.village.status
      when 'not_started', 'ended'
        record.village.player_from_user(user)
      when 'in_play'
        record.village.player_from_user(user)&.alive?
      else
        false
      end
    end
  end
end
