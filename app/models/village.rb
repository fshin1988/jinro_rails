# == Schema Information
#
# Table name: villages
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  name             :string(255)      not null
#  player_num       :integer          not null
#  day              :integer          default(0), not null
#  next_update_time :datetime
#  discussion_time  :integer          not null
#  status           :integer          default("not_started"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
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
  has_many :results

  validates :name, presence: true, length: {maximum: 50}
  validates :player_num, presence: true,
                         numericality: {only_integer: true, greater_than_or_equal_to: 5, less_than_or_equal_to: 16}
  validates :day, presence: true
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
    if voted_players.blank?
      voted_players = players.alive
    end
    exclude(voted_players)
  end

  def attack
    attacked_players = players_from_records(:attack_target)
    if attacked_players.blank?
      attacked_players = players.alive.select(&:human?)
    end
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

  def make_player_exit(user)
    player = players.find_by(user: user)
    player.update!(village_id: 0)
  end

  def prepare_records
    players.alive.each do |p|
      records.create!(player: p, day: day)
    end
  end

  def prepare_result
    results.create!(day: day)
  end

  def update_divined_player_of_result
    divined_player_id = players.fortune_teller.first.records.find_by(day: day)&.divine_target_id
    results.find_by(day: day).update!(divined_player_id: divined_player_id)
  end

  def update_guarded_player_of_result
    guarded_player_id = players.bodyguard.first.records.find_by(day: day)&.guard_target_id
    results.find_by(day: day).update(guarded_player_id: guarded_player_id)
  end

  def room_for_all
    rooms.for_all.first
  end

  def room_for_wolf
    rooms.for_wolf.first
  end

  def record_from_user(user)
    records.where(player: player_from_user(user), day: day).first
  end

  # 残り時間(秒)を返す
  def remaining_time
    time = (next_update_time - Time.now).to_i
    time > 0 ? time : 0
  end

  def divine_results(user)
    return if day < 2
    results = {}
    records_until_yesterday(user).pluck(:divine_target_id).compact.each do |id|
      results[Player.find(id).username] = Player.find(id).human?
    end
    results
  end

  private

  def players_from_records(target)
    records.select { |r| r.day == day }.map(&target).compact
  end

  def exclude(target_players, guarded_player = nil)
    count_by_id = Hash.new(0)
    target_players.each { |p| count_by_id[p.id] += 1 }
    max = count_by_id.values.max
    players_of_max_number = count_by_id.select { |_k, v| v == max }
    # if there are multiple players who are voted maximum number, choose one player randomly
    player = Player.find(players_of_max_number.to_a.sample[0])
    return nil if player == guarded_player
    player.update(status: 'dead')
    player
  end

  def create_rooms
    rooms.create!(room_type: :for_all)
    rooms.create!(room_type: :for_wolf)
  end

  def records_until_yesterday(user)
    yesterday = day - 1
    records.where(player: player_from_user(user)).where(day: 1..yesterday)
  end
end
