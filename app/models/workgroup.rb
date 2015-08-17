class Workgroup < ActiveRecord::Base
  validates :name, presence: true

  has_many :user_workgroups
  has_many :users, through: :user_workgroups
  has_many :event_workgroups
  has_many :events, through: :event_workgroups

  belongs_to :school
end
