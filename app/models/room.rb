# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  village_id :integer          not null
#  room_type  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_rooms_on_village_id  (village_id)
#

class Room < ApplicationRecord
end
