# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  village_id :integer          not null
#  role       :integer          not null
#  status     :integer          not null
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
  before_validation :set_username, on: :create

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
  belongs_to :village
  has_many :posts
  has_many :records

  validates :role, presence: true
  validates :status, presence: true

  def human?
    villager? || fortune_teller? || psychic? || bodyguard? || madman?
  end

  def avatar_image_src
    @avatar_image_src ||=
      if user && user.avatar.attached?
        # user.avatar.variant becomes NoMethodError
        begin
          url_for(user.avatar.variant(resize: "100x100"))
        rescue NoMethodError => ex
          logger.error { ["\n", ex, ex.backtrace, "\n"].join("\n") }
          nil
        end
      else
        nil
      end
  end

  private

  # player have username because user can be destroyed and user.username can be changed
  def set_username
    self.username = user.username
  end

  def url_for(image)
    routes = Rails.application.routes
    routes.default_url_options = {host: ENV["HOST_NAME"], protocol: protocol_option}
    routes.url_helpers.url_for(image)
  end

  def protocol_option
    if Rails.env.production?
      'https'
    else
      'http'
    end
  end
end
