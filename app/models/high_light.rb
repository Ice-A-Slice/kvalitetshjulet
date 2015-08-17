class HighLight < ActiveRecord::Base
  belongs_to :user
  validates :week, :year, :color, :user_id,  presence: true
  validates :week, numericality: {greater_than_or_equal_to: 1}
  validates :week, numericality: {less_than_or_equal_to: 52}
end

#--> Review by Niklas 10:44 11/3-14