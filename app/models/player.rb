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

class Player < ApplicationRecord
  after_update_commit :upload_variant_avatar

  attr_accessor :access_password

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

  validates :username, presence: true, length: {in: 1..20}
  validate :username_must_be_unique_in_village
  validates :role, presence: true
  validates :status, presence: true
  validate :check_access_password, if: :need_access_password?, on: :create

  def human?
    villager? || fortune_teller? || psychic? || bodyguard? || madman?
  end

  def avatar_image_src
    @avatar_image_src ||=
      # if blob is invalid for ImageMagick, ActiveStorage::InvariableError occurs in `avatar.variant`
      if avatar.attached?
        begin
          url_for(avatar.variant(resize: "100x100"))
        rescue ActiveStorage::InvariableError
          nil
        end
      elsif user && user.avatar.attached?
        begin
          url_for(user.avatar.variant(resize: "100x100"))
        rescue ActiveStorage::InvariableError
          nil
        end
      else
        nil
      end
  end

  def exit_from_village
    update!(village_id: 0)
  end

  def need_access_password?
    village.access_password.present?
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
    return unless village.players.where(username: username).where.not(id: id).present?
    errors.add(:base, "村内で同一ユーザーネームのプレイヤーが存在します")
  end

  def upload_variant_avatar
    return unless avatar.attached?
    UploadVariantAvatarJob.perform_later(self)
  end

  def check_access_password
    return if access_password == village.access_password
    errors.add(:base, "アクセスコードが誤っています")
  end
end
