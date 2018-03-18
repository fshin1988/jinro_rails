class AddAccessPasswordToVillages < ActiveRecord::Migration[5.2]
  def change
    add_column :villages, :access_password, :string
  end
end
