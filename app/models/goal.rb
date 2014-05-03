class Goal < ActiveRecord::Base
  validates :title, :presence => true, :length => { minimum: 6 }
  belongs_to :author, 
             :class_name => "User", 
             :primary_key => :id,
             :foreign_key => :user_id
  has_many :cheers
  has_many :comments, as: :commentable
  
  def cheered_by?(user)
    (self.cheers.where("giver_id = ?", user.id).length) > 0
  end
end
