# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Notification < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
end
