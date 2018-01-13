class CreateBlacklistUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :blacklist_users do |t|
      t.references :village, null: false
      t.references :user, null: false

      t.timestamps
    end
  end
end
