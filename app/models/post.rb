# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  player_id  :integer
#  room_id    :integer          not null
#  content    :text             not null
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
  before_validation :compress_content_size
  after_create_commit { MessageBroadcastJob.perform_later self }

  enum owner: {
    player: 0,
    system: 1
  }

  belongs_to :player, optional: true
  belongs_to :room

  validates :player_id, presence: true, if: :player?
  validates :content, presence: true
  validates :day, presence: true

  private

  def compress_content_size
    self.content = content[0, 500] if content.size > 500
  end
end
