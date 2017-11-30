class CreateResults < ActiveRecord::Migration[5.1]
  def change
    create_table :results do |t|
      t.references :village, null: false
      t.integer :day, null: false
      t.bigint :voted_player_id
      t.bigint :attacked_player_id
      t.bigint :divined_player_id
      t.bigint :guarded_player_id

      t.timestamps
    end
  end
end
