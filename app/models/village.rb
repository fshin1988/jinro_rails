# == Schema Information
#
# Table name: villages
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  player_num      :integer          not null
#  day             :integer          not null
#  start_time      :datetime         not null
#  discussion_time :integer          not null
#  status          :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Village < ApplicationRecord
  enum status: {
    not_started: 0,
    in_play: 1,
    ended: 2
  }

  has_many :rooms
  has_many :players
  has_many :records

  validates :name, presence: true, length: {maximum: 50}
  validates :player_num, presence: true,
                         numericality: {only_integer: true, greater_than_or_equal_to: 5, less_than_or_equal_to: 16}
  validates :day, presence: true
  validates :start_time, presence: true
  validates :discussion_time, presence: true,
                              numericality: {only_integer: true, less_than_or_equal_to: 1440}
  validates :status, presence: true

  def assign_role
    roles = Settings.role_list[player_num].shuffle
    players.each do |p|
      r = roles.pop
      p.update(role: r)
    end
  end

  def lynch
    voted_players = records_by_day(:vote_target)
    exclude(voted_players)
  end

  def attack
    attacked_players = records_by_day(:attack_target)
    guarded_player = records_by_day(:guard_target).first
    exclude(attacked_players, guarded_player)
  end

  private

  def records_by_day(target)
    records.select { |r| r.day == day }.map(&target).compact
  end

  def exclude(players, guarded_player = nil)
    count_by_id = Hash.new(0)
    players.each do |p|
      count_by_id[p.id] += 1
    end
    max = count_by_id.values.max
    targets = count_by_id.select { |_k, v| v == max }
    # if there are multiple players to exclude, choose one player randomly
    exclude_id = targets.to_a.sample[0]
    return if exclude_id == guarded_player&.id
    Player.find(exclude_id).update(status: 'dead')
  end
end
