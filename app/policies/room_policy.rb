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
end
