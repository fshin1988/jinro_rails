# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string           not null
#  role                   :integer          default("normal"), not null
#  locked_at              :datetime
#

class User < ApplicationRecord
  after_update_commit :upload_variant_avatar

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  enum role: {
    normal: 0,
    admin: 1
  }

  has_many :villages
  has_many :players
  has_one_attached :avatar

  validates :username, presence: true, length: {in: 1..20}, uniqueness: true
  validates :role, presence: true

  def joining_in_village?
    if players.includes(:village).find { |p| p.village && (p.village.not_started? || p.village.in_play?) }
      true
    else
      false
    end
  end

  def joined_village_count(role: nil)
    p = players.joins(:village).where(villages: {status: :ended})
    p = p.where(role: role) if role
    p.count
  end

  private

  def upload_variant_avatar
    return unless avatar.attached?
    UploadVariantAvatarJob.perform_later(self)
  end
end
