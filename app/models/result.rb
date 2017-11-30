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
# Indexes
#
#  index_results_on_village_id  (village_id)
#

class Result < ApplicationRecord
end
