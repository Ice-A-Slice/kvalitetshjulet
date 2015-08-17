class EventWorkgroup < ActiveRecord::Base
  belongs_to :event
  belongs_to :workgroup
end
