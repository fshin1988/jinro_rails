# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  village_id :integer          not null
#  role       :integer          not null
#  status     :integer          not null
#  username   :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_players_on_user_id     (user_id)
#  index_players_on_village_id  (village_id)
#

class Player < ApplicationRecord
  before_validation :set_username, on: :create

  enum role: {
    villager: 0,
    werewolf: 1,
    fortune_teller: 2,
    psychic: 3,
    bodyguard: 4,
    madman: 5
  }

  enum status: {
    alive: 0,
    dead: 1
  }

  belongs_to :user
  belongs_to :village
  has_many :posts
  has_many :records

  validates :role, presence: true
  validates :status, presence: true

  def human?
    villager? || fortune_teller? || psychic? || bodyguard? || madman?
  end

  private

  # player have username because user can be destroyed and user.username can be changed
  def set_username
    self.username = user.username
  end
end
