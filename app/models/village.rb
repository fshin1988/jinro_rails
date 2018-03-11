# == Schema Information
#
# Table name: villages
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  name             :string           not null
#  player_num       :integer          not null
#  day              :integer          default(0), not null
#  next_update_time :datetime
#  discussion_time  :integer          not null
#  status           :integer          default("not_started"), not null
#  winner           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  first_day_victim :boolean          default(TRUE), not null
#  start_at         :datetime
#  show_vote_target :boolean          default(TRUE), not null
#

class Village < ApplicationRecord
  after_create :create_rooms

  enum status: {
    not_started: 0,
    in_play: 1,
    ended: 2,
    ruined: 3
  }

  enum winner: {
    human_win: 0,
    werewolf_win: 1
  }

  belongs_to :user
  has_many :rooms, dependent: :destroy
  has_many :players, dependent: :destroy
  has_many :records
  has_many :results
  has_many :blacklist_users

  validates :name, presence: true, length: {maximum: 50}
  validates :player_num, presence: true,
                         numericality: {only_integer: true, greater_than_or_equal_to: 5, less_than_or_equal_to: 16}
  validate :player_num_must_be_greater_than_current_num, on: :update
  validates :day, presence: true
  validates :discussion_time, presence: true,
                              numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 1440}
  validates :status, presence: true

  def assign_role
    roles = Settings.role_list[player_num].shuffle
    players.each do |p|
      r = roles.pop
      p.update(role: r)
    end
  end

  def lynch
    voted_players =
      if vote_target_players.present?
        vote_target_players
      else
        players.alive
      end
    excluded_player = exclude(voted_players)
    result_of_today.update!(voted_player: excluded_player)
  end

  def attack
    return unless attack_on_today?
    attacked_players =
      if attack_target_players.present?
        attack_target_players
      else
        players.alive.select(&:human?)
      end
    guarded_player = guard_target_player
    excluded_player = exclude(attacked_players, guarded_player)
    result_of_today.update!(attacked_player: excluded_player)
  end

  def judge_end
    human_count = players.alive.select(&:human?).count
    wolf_count = players.alive.werewolf.count

    if human_count <= wolf_count
      :werewolf_win
    elsif wolf_count.zero?
      :human_win
    else
      :continued
    end
  end

  def player_from_user(user)
    return unless user
    players.includes(:user).find { |p| p.user == user }
  end

  def make_player_exit(user)
    player = players.find_by(user: user)
    player.update!(village_id: 0)
    player
  end

  def kick_player(player)
    make_player_exit(player.user)
    blacklist_users.create!(user: player.user)
  end

  def update_to_next_day
    update!(day: day + 1, next_update_time: Time.now + discussion_time.minutes)
    ProceedVillageJob.set(wait: discussion_time.minutes).perform_later(self)
    prepare_records
    prepare_result
  end

  def update_results
    update_divined_player_of_result
    update_guarded_player_of_result
  end

  def room_for_all
    rooms.for_all.first
  end

  def room_for_wolf
    rooms.for_wolf.first
  end

  def room_for_dead
    rooms.for_dead.first
  end

  def record_from_user(user)
    records.where(player: player_from_user(user), day: day).first
  end

  # Return remaining time by seconds
  def remaining_time
    time = (next_update_time - Time.now).to_i
    time > 0 ? time : 0
  end

  def divine_results
    results.pluck(:divined_player_id).compact.each_with_object({}) do |id, hash|
      hash[Player.find(id).username] = Player.find(id).human?
    end
  end

  def vote_results
    results.pluck(:voted_player_id).compact.each_with_object({}) do |id, hash|
      hash[Player.find(id).username] = Player.find(id).human?
    end
  end

  def result_of_today
    results.find_by(day: day)
  end

  def post_system_message(content)
    room_for_all.posts.create!(content: content, day: day, owner: :system)
  end

  def attack_on_today?
    return false if first_day_victim == false && day == 1
    true
  end

  def number_of_votes
    count_by_username(vote_target_players)
  end

  def start!
    assign_role
    update_to_next_day
    update!(status: :in_play)
  end

  private

  def vote_target_players
    records_of_today.includes(:vote_target).map(&:vote_target).compact
  end

  def attack_target_players
    records_of_today.includes(:attack_target).map(&:attack_target).compact
  end

  def guard_target_player
    bodyguard = players.alive.bodyguard.first
    return nil unless bodyguard
    records_of_today.find_by(player: bodyguard).guard_target
  end

  def exclude(target_players, guarded_player = nil)
    counts = count_by_id(target_players)
    max = counts.values.max
    # if there are multiple players who are voted maximum number, choose one player randomly
    excluded_player = Player.find(player_ids_of_max_number(counts, max).sample)
    return nil if excluded_player == guarded_player || excluded_player.dead?
    excluded_player.update!(status: 'dead')
    excluded_player
  end

  def count_by_id(target_players)
    target_players.each_with_object(Hash.new(0)) do |player, hash|
      hash[player.id] += 1
    end
  end

  def count_by_username(target_players)
    target_players.each_with_object(Hash.new(0)) do |player, hash|
      hash[player.username] += 1
    end
  end

  def player_ids_of_max_number(counts, max)
    counts.map do |id, count|
      id if count == max
    end.compact
  end

  def create_rooms
    rooms.create!(room_type: :for_all)
    rooms.create!(room_type: :for_wolf)
    rooms.create!(room_type: :for_dead)
  end

  def player_num_must_be_greater_than_current_num
    errors.add(:player_num, "は現在のプレイヤー数(#{players.count})以上に設定してください") if player_num < players.count
  end

  def prepare_records
    players.alive.each do |p|
      records.create!(player: p, day: day)
    end
  end

  def prepare_result
    results.create!(day: day)
  end

  def records_of_today
    records.where(day: day)
  end

  def update_divined_player_of_result
    return unless players.alive.fortune_teller.present?
    divine_target = records_of_today.find_by(player: players.fortune_teller.first).divine_target
    result_of_today.update!(divined_player: divine_target)
  end

  def update_guarded_player_of_result
    return unless players.alive.bodyguard.present?
    guard_target = records_of_today.find_by(player: players.bodyguard.first).guard_target
    result_of_today.update(guarded_player: guard_target)
  end
end
