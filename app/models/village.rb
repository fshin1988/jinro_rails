# == Schema Information
#
# Table name: villages
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  player_num      :integer          not null
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
                         numericality: {only_integer: true, greater_than_or_equal_to: 4, less_than_or_equal_to: 13}
  validates :start_time, presence: true
  validates :discussion_time, presence: true,
                              numericality: {only_integer: true, less_than_or_equal_to: 1440}
  validates :status, presence: true

  def assign_role
    roles = role_list.shuffle
    players.each do |p|
      role = roles.pop
      p.update(role: role)
    end
  end

  def role_list
    case player_num
    when 10
      [['villager']*6, ['werewolf']*2, ['fortune_teller']*1, ['psychic']*1].flatten
    when 11
      [['villager']*5, ['werewolf']*2, ['fortune_teller']*1, ['psychic']*1, ['bodyguard']*1, ['madman']*1].flatten
    when 12
      [['villager']*6, ['werewolf']*2, ['fortune_teller']*1, ['psychic']*1, ['bodyguard']*1, ['madman']*1].flatten
    when 13
      [['villager']*6, ['werewolf']*3, ['fortune_teller']*1, ['psychic']*1, ['bodyguard']*1, ['madman']*1].flatten
    when 14
      [['villager']*7, ['werewolf']*3, ['fortune_teller']*1, ['psychic']*1, ['bodyguard']*1, ['madman']*1].flatten
    when 15
      [['villager']*8, ['werewolf']*3, ['fortune_teller']*1, ['psychic']*1, ['bodyguard']*1, ['madman']*1].flatten
    when 16
      [['villager']*9, ['werewolf']*3, ['fortune_teller']*1, ['psychic']*1, ['bodyguard']*1, ['madman']*1].flatten
    end
  end
end
