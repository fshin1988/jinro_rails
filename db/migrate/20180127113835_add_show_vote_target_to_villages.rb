class AddShowVoteTargetToVillages < ActiveRecord::Migration[5.2]
  def change
    add_column :villages, :show_vote_target, :boolean, null: false, default: true
  end
end
