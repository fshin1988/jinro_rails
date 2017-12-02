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

  def start_message(village)
    message = ""
    message << "この中には"
    Player.roles.keys.each do |role|
      count = role_count(village, role)
      next if count == 0
      message << "、#{I18n.t("activerecord.attributes.player.role_enums.#{role}")}が#{count}名"
    end
    message << "います\n"
    message << "それでは今から、人狼を見つけるために話し合ってください"
  end

  def noon_message(village)
    message = ""
    village.records.where(day: village.day).each do |record|
      if record.vote_target
        message << "#{record.player.username}は #{record.vote_target.username} に投票した\n"
      else
        message << "#{record.player.username}は投票しなかった\n"
      end
    end
    message << "投票の結果、#{village.results_of_today.voted_player.username}は処刑された"
  end

  private

  def human_or_werewolf(bool)
    return "人間" if bool
    "人狼"
  end

  def role_count(village, role)
    Settings.role_list[village.player_num].count(role)
  end
end
