# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  player_id  :integer          not null
#  room_id    :integer          not null
#  content    :text(65535)      not null
#  day        :integer          not null
#  owner      :integer          default("player"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_posts_on_player_id  (player_id)
#  index_posts_on_room_id    (room_id)
#

class Post < ApplicationRecord
  enum owner: {
    player: 0,
    system: 1
  }

  belongs_to :player
  belongs_to :room

  validates :content, presence: true
  validates :day, presence: true
end
