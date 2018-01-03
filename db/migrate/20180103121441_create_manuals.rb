class CreateManuals < ActiveRecord::Migration[5.2]
  def change
    create_table :manuals do |t|
      t.text :content

      t.timestamps
    end
  end
end
