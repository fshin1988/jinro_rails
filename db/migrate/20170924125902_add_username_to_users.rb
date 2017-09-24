class AddUsernameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :username, :string, null: false, after: :email
  end
end
