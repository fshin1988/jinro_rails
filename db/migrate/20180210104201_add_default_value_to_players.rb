class AddDefaultValueToPlayers < ActiveRecord::Migration[5.2]
  def change
    change_column_default :players, :role, 0
    change_column_default :players, :status, 0
  end
end
