class CreateRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :records do |t|
      t.references :player, null: false
      t.integer :day, null: false
      t.bigint :vote_target, null: false
      t.bigint :attack_target
      t.bigint :divine_target
      t.bigint :guard_target

      t.timestamps
    end
  end
end
