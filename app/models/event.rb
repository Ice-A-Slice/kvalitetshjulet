class Event < ActiveRecord::Base
  belongs_to :user_or_school, polymorphic: true
  has_one :event_workgroup
  belongs_to :event_type, :foreign_key => 'type_id'
  has_one :workgroup, through: :event_workgroup
  validates :week, :title, :datetime, :type_id, presence: true
  validates :week, numericality: {greater_than_or_equal_to: 0}
  validates :week, numericality: {less_than_or_equal_to: 51}
  mount_uploader :file, FileUploader
  validates_integrity_of  :file
  validates_processing_of :file

  def self.by_year(year)
    where("strftime('%Y', created_at) = ?", year)
  end

  # default_scope where("strftime('%Y', created_at) = ?", 2014)
end


#--> Review by Niklas 10:44 11/3-14