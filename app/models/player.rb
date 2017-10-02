# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  village_id :integer          not null
#  role       :integer          not null
#  status     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_players_on_user_id     (user_id)
#  index_players_on_village_id  (village_id)
#

class Player < ApplicationRecord
end
