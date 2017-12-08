class RecordPolicy < ApplicationPolicy
  def update?
    if record.player_id == record.village.player_from_user(user).id && record.village.player_from_user(user).alive?
      true
    else
      false
    end
  end
end
