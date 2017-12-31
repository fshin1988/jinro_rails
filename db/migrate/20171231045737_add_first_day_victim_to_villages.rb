class AddFirstDayVictimToVillages < ActiveRecord::Migration[5.2]
  def change
    add_column :villages, :first_day_victim, :boolean, null: false, after: :discussion_time, default: true
  end
end
