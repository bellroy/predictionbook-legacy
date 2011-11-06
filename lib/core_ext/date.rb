class Date
  alias_method :'-_with_as_check', :-
  def -(other)
    other = other.to_datetime if other.is_a?(ActiveSupport::TimeWithZone)
    self.send(:'-_with_as_check', other)
  end
end
