# == Schema Information
#
# Table name: records
#
#  id               :integer          not null, primary key
#  village_id       :integer          not null
#  player_id        :integer          not null
#  day              :integer          not null
#  vote_target_id   :integer
#  attack_target_id :integer
#  divine_target_id :integer
#  guard_target_id  :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Record < ApplicationRecord
  belongs_to :village
  belongs_to :player
  belongs_to :vote_target, class_name: 'Player', optional: true
  belongs_to :attack_target, class_name: 'Player', optional: true
  belongs_to :divine_target, class_name: 'Player', optional: true
  belongs_to :guard_target, class_name: 'Player', optional: true

  validates :day, presence: true
end
