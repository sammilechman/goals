class Cheer < ActiveRecord::Base
  CHEER_LIMIT = 12
  validates :giver_id, :goal_id, :presence => true
  validates :goal_id, :uniqueness => { :scope => :giver_id }
  
  belongs_to :giver, :class_name => "User"
  belongs_to :goal
end
