# == Schema Information
#
# Table name: villages
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  player_num      :integer          not null
#  start_time      :datetime         not null
#  discussion_time :integer          not null
#  status          :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Village < ApplicationRecord
  enum status: {
    not_started: 0,
    in_play: 1,
    ended: 2
  }

  has_many :rooms
  has_many :players
end
