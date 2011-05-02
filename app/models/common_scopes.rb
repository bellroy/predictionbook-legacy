module CommonScopes
  def self.included(base)
    base.named_scope :limit, lambda { |*args| {:limit => args.first || 3} } #Splat to stop block params warning
    base.named_scope :sort, lambda { |*args| {:order => "#{args.first || :created_at}"} }
    base.named_scope :rsort, lambda { |*args| {:order => "#{args.first || :created_at} DESC"} }
  end
end
