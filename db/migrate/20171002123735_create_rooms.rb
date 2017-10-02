class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.references :village, null: false
      t.integer :room_type, null: false

      t.timestamps
    end
  end
end
