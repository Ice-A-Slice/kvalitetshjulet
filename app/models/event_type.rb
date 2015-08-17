class EventType < ActiveRecord::Base
    validates :name, :color, :presence => true
    has_many :events, :foreign_key => 'type_id'
    after_destroy :ensure_one_type_remains

    private
        def ensure_one_type_remains
            if EventType.count.zero?
                raise "Det måste alltid finnas minst en aktivitetstyp"
            end
        end
end
