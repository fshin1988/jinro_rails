module VillagesHelper
  def messages_of_result(results)
    return [] unless results
    messages = []
    results.each do |k, v|
      messages << "#{k}は#{human_or_werewolf(v)}です"
    end
    messages
  end

  def join_message(village, player)
    "#{village.players.count}人目、#{player.username}が参加しました"
  end

  def exit_message(player)
    "#{player.username}が退出しました"
  end

  private

  def human_or_werewolf(bool)
    return "人間" if bool
    "人狼"
  end
end
