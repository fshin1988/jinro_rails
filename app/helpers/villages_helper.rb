module VillagesHelper
  def divine_message(divine_results)
    message = ""
    divine_results.each do |k, v|
      message << "#{k}は#{human_or_werewolf(v)}です\n"
    end
    simple_format(message.strip)
  end

  private

  def human_or_werewolf(bool)
    return "人間" if bool
    "人狼"
  end
end
