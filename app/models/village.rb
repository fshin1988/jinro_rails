# == Schema Information
#
# Table name: villages
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  name            :string(255)      not null
#  player_num      :integer          not null
#  day             :integer          default(0), not null
#  start_time      :datetime         not null
#  discussion_time :integer          not null
#  status          :integer          default("not_started"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_villages_on_user_id  (user_id)
#

class Village < ApplicationRecord
  after_create :create_rooms

  enum status: {
    not_started: 0,
    in_play: 1,
    ended: 2
  }

  belongs_to :user
  has_many :rooms
  has_many :players
  has_many :records

  validates :name, presence: true, length: {maximum: 50}
  validates :player_num, presence: true,
                         numericality: {only_integer: true, greater_than_or_equal_to: 5, less_than_or_equal_to: 16}
  validates :day, presence: true
  validates :start_time, presence: true
  validate :start_time_cannot_be_in_the_past
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
    voted_players = players_from_records(:vote_target)
    exclude(voted_players)
  end

  def attack
    attacked_players = players_from_records(:attack_target)
    guarded_player = players_from_records(:guard_target).first
    exclude(attacked_players, guarded_player)
  end

  def judge_end
    human_count = players.alive.select(&:human?).count
    wolf_count = players.alive.werewolf.count

    if human_count <= wolf_count
      2
    elsif wolf_count.zero?
      1
    else
      0
    end
  end

  def player_from_user(user)
    players.includes(:user).find { |p| p.user == user }
  end

  def create_player(user)
    players.create!(user: user, role: :villager, status: :alive)
  end

  private

  def players_from_records(target)
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

  def start_time_cannot_be_in_the_past
    if start_time.present? && start_time < Time.now
      errors.add(:start_time, 'は過去の日時を使用できません')
    end
  end

  def create_rooms
    rooms.create!(room_type: :for_all)
    rooms.create!(room_type: :for_wolf)
  end
end
