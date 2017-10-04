class CreateRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :records do |t|
      t.references :player, null: false
      t.integer :day, null: false
      t.bigint :vote_target_id, null: false
      t.bigint :attack_target_id
      t.bigint :divine_target_id
      t.bigint :guard_target_id

      t.timestamps
    end
  end
end
