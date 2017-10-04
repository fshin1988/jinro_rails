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
  enum room_type: {
    for_all: 0,
    for_wolf: 1
  }

  belongs_to :village
  has_many :posts
end
