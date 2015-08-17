class School < ActiveRecord::Base
  validates :name, presence: true
  has_many :school_users
  has_many :workgroups
  has_many :events, as: :user_or_school
  has_many :users, through: :school_users
  mount_uploader :file, CenterImageUploader
  validates_integrity_of  :file
  validates_processing_of :file
end

