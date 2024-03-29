require 'bcrypt'

class User < ActiveRecord::Base
  attr_reader :password
  
  validates :session_token, :presence => true
  validates :username, :uniqueness => true, :presence => true
  validates :password, :length => { :in => 6..12, :allow_nil => true }
  validates :password_digest, :presence => { 
    :message => "Password can't be blank." }
  validates :cheer_count, :numericality => { :only_integer => true,
    :minimum => 0 }
  before_validation :ensure_session_token
  before_validation :ensure_cheer_count
  has_many :goals, :class_name => "Goal", :foreign_key => "user_id"
  
  has_many :cheers_given, :class_name => "Cheer", :foreign_key => "giver_id"
  has_many :cheers_received, :through => :goals, :source => :cheers
  has_many :comments, as: :commentable
  
  def self.find_by_credentials(username, password)
    user_by_un = User.find_by_username(username)
    return nil unless user_by_un
    user_by_un.is_password?(password) ? user_by_un : nil
  end
  
  def self.generate_session_token
    SecureRandom::urlsafe_base64(32)
  end
  
  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
  end
  
  def decrement_cheer_count!
    self.cheer_count = self.cheer_count - 1
    self.save!
  end
  
  def is_password?(maybe_password)
    BCrypt::Password.new(self.password_digest).is_password?(maybe_password)
  end
  
  def password=(new_pw)
    @password = new_pw
    self.password_digest = BCrypt::Password.create(new_pw)
  end
  
  def password
    @password
  end
  
  private
  
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
  
  def ensure_cheer_count
    if self.cheer_count.nil?
      self.cheer_count = Cheer::CHEER_LIMIT
    end
  end
    
end
