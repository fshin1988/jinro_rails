class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.references :player, null: false
      t.references :room, null: false
      t.text :content, null: false
      t.integer :day, null: false

      t.timestamps
    end
  end
end
