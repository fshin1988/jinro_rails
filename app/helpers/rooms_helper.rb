module RoomsHelper
  def room_title(village)
    "#{village.name} #{room_day(village)}"
  end

  def room_day(village)
    if village.day == 0
      "プロローグ"
    elsif village.ended?
      "エピローグ"
    else
      "#{village.day}日目"
    end
  end
end
