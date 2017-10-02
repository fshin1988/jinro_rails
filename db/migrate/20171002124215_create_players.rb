class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.references :user, null: false
      t.references :village, null: false
      t.integer :role, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
