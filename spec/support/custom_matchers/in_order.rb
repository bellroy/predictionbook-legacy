module CustomMatchers
  def contain_in_order(args)
    simple_matcher "#{args.inspect} in the specified order" do |actual|
      # depends on Array#& using the order of the first list
      # safe according to rubyspec.org
      (actual & args) == args
    end
  end
end
