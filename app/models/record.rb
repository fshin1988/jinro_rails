# == Schema Information
#
# Table name: records
#
#  id            :integer          not null, primary key
#  player_id     :integer          not null
#  day           :integer          not null
#  vote_target   :integer          not null
#  attack_target :integer
#  divine_target :integer
#  guard_target  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_records_on_player_id  (player_id)
#

class Record < ApplicationRecord
end
