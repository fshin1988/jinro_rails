class CreateVillages < ActiveRecord::Migration[5.1]
  def change
    create_table :villages do |t|
      t.references :user, null: false
      t.string :name, null: false
      t.integer :player_num, null: false
      t.integer :day, default: 0, null: false
      t.datetime :next_update_time
      t.integer :discussion_time, null: false
      t.integer :status, default: 0, null: false
      t.integer :winner

      t.timestamps null: false
    end
  end
end
