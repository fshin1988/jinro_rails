class RoomPolicy < ApplicationPolicy
  def show?
    if record.for_wolf?
      case record.village.status
      when 'in_play'
        player_of_village&.werewolf?
      when 'ended', 'ruined'
        true
      else
        false
      end
    elsif record.for_dead?
      case record.village.status
      when 'in_play'
        player_of_village&.dead?
      when 'ended', 'ruined'
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
        player_of_village&.werewolf? && player_of_village&.alive?
      else
        false
      end
    elsif record.for_dead?
      case record.village.status
      when 'in_play'
        player_of_village&.dead?
      else
        false
      end
    else
      case record.village.status
      when 'not_started', 'ended'
        player_of_village
      when 'in_play'
        player_of_village&.alive?
      else
        false
      end
    end
  end

  def posts?
    true
  end

  def all_posts?
    posts?
  end

  private

  def player_of_village
    record.village.player_from_user(user)
  end
end
