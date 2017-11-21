class RoomPolicy < ApplicationPolicy
  def show?
    if record.for_wolf?
      record.village.player_from_user(user)&.werewolf?
    else
      true
    end
  end
end
