module ProfilesHelper
  def winning_percentage(winned_count, joined_count)
    return "-" if joined_count.zero?
    number_to_percentage(winned_count / joined_count.to_f * 100, precision: 2)
  end
end
