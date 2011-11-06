module DatetimeDescriptionHelper
  def time_in_words_with_context(time)
    time_str = time_ago_in_words(time)
    if time <= Time.now
      "#{time_str} ago"
    else
      "in #{time_str}"
    end
  rescue RangeError,NoMethodError # known issue in Rails
    "in ages"
  end
end
