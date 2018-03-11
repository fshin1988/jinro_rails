# == Schema Information
#
# Table name: manuals
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Manual < ApplicationRecord
  validates :content, presence: true
end
