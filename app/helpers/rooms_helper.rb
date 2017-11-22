module RoomsHelper
  def room_title(village)
    "#{village.name} #{room_day(village.day)}"
  end

  def room_day(day)
    if day == 0
      "プロローグ"
    else
      "#{day}日目"
    end
  end
end
