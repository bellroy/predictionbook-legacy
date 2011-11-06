class Time
  def noon
    change(:hour => 12)
  end
  alias_method :at_noon, :noon
end
