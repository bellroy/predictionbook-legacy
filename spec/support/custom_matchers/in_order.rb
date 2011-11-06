module CustomMatchers
  RSpec::Matchers.define  :contain_in_order do |expected|
    # depends on Array#& using the order of the first list
    # safe according to rubyspec.org
    match do |actual|
      (actual & expected) == expected
    end
  end
end
