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
# Indexes
#
#  index_blacklist_users_on_user_id     (user_id)
#  index_blacklist_users_on_village_id  (village_id)
#

class BlacklistUser < ApplicationRecord
  belongs_to :village
  belongs_to :user
end
