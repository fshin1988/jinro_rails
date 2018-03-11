# == Schema Information
#
# Table name: blacklist_users
#
#  id         :integer          not null, primary key
#  village_id :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BlacklistUser < ApplicationRecord
  belongs_to :village
  belongs_to :user
end
