module RecordsHelper
  def attack_target_set_message(record)
    "#{record.player.username} が #{record.attack_target.username} を襲撃先にセットしました"
  end
end
