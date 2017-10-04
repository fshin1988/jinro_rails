# == Schema Information
#
# Table name: records
#
#  id               :integer          not null, primary key
#  player_id        :integer          not null
#  day              :integer          not null
#  vote_target_id   :integer          not null
#  attack_target_id :integer
#  divine_target_id :integer
#  guard_target_id  :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_records_on_player_id  (player_id)
#

class Record < ApplicationRecord
  belongs_to :player
  belongs_to :vote_target, class_name: 'Player'
  belongs_to :attack_target, class_name: 'Player', optional: true
  belongs_to :divine_target, class_name: 'Player', optional: true
  belongs_to :guard_target, class_name: 'Player', optional: true
end
