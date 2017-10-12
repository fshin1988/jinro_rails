class CreateVillages < ActiveRecord::Migration[5.1]
  def change
    create_table :villages do |t|
      t.string :name, null: false
      t.integer :player_num, null: false
      t.integer :day, default: 0, null: false
      t.datetime :start_time, null: false
      t.integer :discussion_time, null: false
      t.integer :status, default: 0, null: false

      t.timestamps null: false
    end
  end
end
