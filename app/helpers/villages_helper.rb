module VillagesHelper
  def messages_of_result(results)
    return [] unless results
    messages = []
    results.each do |k, v|
      messages << "#{k}は#{human_or_werewolf(v)}です"
    end
    messages
  end

  private

  def human_or_werewolf(bool)
    return "人間" if bool
    "人狼"
  end
end
