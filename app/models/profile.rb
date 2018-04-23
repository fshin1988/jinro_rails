# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  comment    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Profile < ApplicationRecord
  belongs_to :user

  validates :comment, length: {maximum: 500}, if: :comment
end
