# == Schema Information
#
# Table name: results
#
#  id                 :integer          not null, primary key
#  village_id         :integer          not null
#  day                :integer          not null
#  voted_player_id    :integer
#  attacked_player_id :integer
#  divined_player_id  :integer
#  guarded_player_id  :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Result < ApplicationRecord
  belongs_to :village
  belongs_to :voted_player, class_name: 'Player', optional: true
  belongs_to :attacked_player, class_name: 'Player', optional: true
  belongs_to :divined_player, class_name: 'Player', optional: true
  belongs_to :guarded_player, class_name: 'Player', optional: true

  validates :day, presence: true
end
