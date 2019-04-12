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

class Post < ApplicationRecord
  before_validation :compress_content_size, if: :player?
  before_validation :prohibit_duplicates, if: :player?
  after_create_commit { MessageBroadcastJob.perform_later self }

  enum owner: {
    player: 0,
    system: 1
  }

  belongs_to :player, optional: true
  belongs_to :room

  validates :player_id, presence: true, if: :player?
  validates :content, presence: true
  validate :prohibit_duplicates
  validates :day, presence: true

  private

  def prohibit_duplicates
    lastpost = Post.where(player_id: player_id).where(room_id: room_id).last
    if lastpost && lastpost.content == content
        @errors.add(:base, '連続投稿はできません')
    end
  end

  def compress_content_size
    self.content = content[0, 500] if content.size > 500
  end
end
