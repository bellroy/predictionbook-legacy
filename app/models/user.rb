class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :encryptable, :encryptor => :restful_authentication_sha1
  
  attr_accessible :email, :login, :password, :password_confirmation, :remember_me 
       
  has_many :responses
  delegate :wagers, :to => :responses
  has_many :predictions, 
    :through => :responses,
    :uniq => true, 
    :conditions => "responses.#{Response::WAGER_CONDITION}",
    :order => 'responses.updated_at DESC'
  has_many :deadline_notifications
  has_many :response_notifications
  
  nillify_blank :email, :name
  
  validates_presence_of     :login
  validates_length_of       :login,    :maximum => 255
  validates_uniqueness_of   :login,    :case_sensitive => false
  #validates_format_of       :login,    :with => RE_LOGIN_OK, :message => "Readable characters only please"

  validates_length_of       :name,     :maximum => 255, :allow_nil => true
  #validates_format_of       :name,     :with => RE_NAME_OK, :message => "Readable characters only please"

  validates_length_of       :email,    :within => 6..100, :allow_nil => true #r@a.wk
  validates_uniqueness_of   :email,    :case_sensitive => false, :allow_nil => true
  #validates_format_of       :email,    :with => /\A#{RE_EMAIL_NAME}@[-A-Z\._]+\z/i, :message => MSG_EMAIL_BAD, :allow_nil => true
  
  #NOTE: You can't set anything via mass assignment that is not in this list
  ## eg. User.new(:foo => 'bar') # will not assign foo
  attr_accessible :login, :email, :name, :password, :password_confirmation, :timezone, :private_default

  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  # find by login
  def self.[](login)
    return if login.blank?
    find_by_login(login.gsub("[dot]",".")) || raise(ActiveRecord::RecordNotFound, "Couldn't find user with login '#{login}'")
  end
  
  delegate :statistics, :to => :wagers
  
  def statistics_image_url
    statistics.image_url
  end
  
  def email_with_name
    %{"#{to_s}" <#{email}>}
  end
  
  def notify_on_overdue?
    has_email?
  end
  def notify_on_judgement?
    has_email?
  end
  
  def has_email?
    !email.blank?
  end

  def authorized_for(prediction)
    if prediction.private?
      self == prediction.creator
    else
      admin? || self == prediction.creator
    end
  end

  def admin?
    %w[matt gwern].include?(login)  # I can imagine this method being slightly more complicated…
  end
  
  def to_param
      login.gsub(".", "[dot]") 
  end
  
  def to_s
    name || login
  end
  
  protected

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(login) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  end
end
