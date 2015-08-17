class SchoolUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :school
  validates :user_id, :school_id, presence: true
  validates :user_id, :uniqueness => {:scope => :school_id}
end

#--> Review by Niklas 10:44 11/3-14