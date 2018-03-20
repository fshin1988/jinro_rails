class RemoveFirstDayVictimFromVillages < ActiveRecord::Migration[5.2]
  def change
    remove_column :villages, :first_day_victim, :boolean
  end
end
