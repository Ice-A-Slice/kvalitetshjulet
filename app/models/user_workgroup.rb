class UserWorkgroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :workgroup
end
