# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  village_id :integer          not null
#  role       :integer          default("villager"), not null
#  status     :integer          default("alive"), not null
#  username   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_players_on_user_id     (user_id)
#  index_players_on_village_id  (village_id)
#

class Player < ApplicationRecord
  after_update_commit :upload_variant_avatar

  enum role: {
    villager: 0,
    werewolf: 1,
    fortune_teller: 2,
    psychic: 3,
    bodyguard: 4,
    madman: 5
  }

  enum status: {
    alive: 0,
    dead: 1
  }

  belongs_to :user
  belongs_to :village, optional: true
  has_many :posts
  has_many :records
  has_one_attached :avatar

  validates :username, presence: true, length: { in: 1..20 }
  validate :username_must_be_unique_in_village
  validates :role, presence: true
  validates :status, presence: true

  def human?
    villager? || fortune_teller? || psychic? || bodyguard? || madman?
  end

  def avatar_image_src
    @avatar_image_src ||=
      if avatar.attached?
        # avatar.variant may become NoMethodError
        begin
          url_for(avatar.variant(resize: "100x100"))
        rescue NoMethodError => ex
          logger.error("NoMethodError in avatar.variant")
          nil
        end
      elsif user && user.avatar.attached?
        # user.avatar.variant may become NoMethodError
        begin
          url_for(user.avatar.variant(resize: "100x100"))
        rescue NoMethodError => ex
          logger.error("NoMethodError in user.avatar.variant")
          nil
        end
      else
        nil
      end
  end

  private

  def url_for(image)
    routes = Rails.application.routes
    routes.default_url_options = {host: Settings.host_name, protocol: protocol_option}
    routes.url_helpers.url_for(image)
  end

  def protocol_option
    if Rails.env.production?
      'https'
    else
      'http'
    end
  end

  def username_must_be_unique_in_village
    # Don't check a player to exit
    return if village_id == 0
    if village.players.where(username: username).where.not(id: id).present?
      errors.add(:base, "村内で同一ユーザーネームのプレイヤーが存在します")
    end
  end

  def upload_variant_avatar
    return unless avatar.attached?
    UploadVariantAvatarJob.perform_later(self)
  end
end
