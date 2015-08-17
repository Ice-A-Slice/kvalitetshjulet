require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test "event attributes must not be empty" do
    event = Event.new
    assert event.invalid?, "Empty event passed validation"
    assert event.errors[:title].any?, "Event passed validation without title"
    assert event.errors[:datetime].any?, "Event passed validation without datetime"
    assert event.errors[:week].any?, "Event passed validation without week"
  end

  #denna metod kan komma att tas bort
  /test "event week number can only be int between 1 and 52" do
    event0 = Event.new(:title => "Mitt Event",
                  :datetime => Time.now,
                  :comment => "Mitt Events innehåll",
                  :user_id => 1)

    event0.week = 0
    assert event0.invalid?, "can be zero"

    event1 = Event.new(:title => "Mitt Event",
                  :datetime => Time.now,
                  :comment => "Mitt Events innehåll",
                  :user_id => 1)
    event1.week = 1
    assert event1.valid?, "week number cant be 1"

    event52 = Event.new(:title => "Mitt Event",
                       :datetime => Time.now,
                       :comment => "Mitt Events innehåll",
                       :user_id => 1)
    event52.week = 52
    assert event52.valid?, "week number cant be 1"

    event53 = Event.new(:title => "Mitt Event",
                        :datetime => Time.now,
                        :comment => "Mitt Events innehåll",
                        :user_id => 1)
    event53.week = 53
    assert event53.invalid?, "can be 53"
  end/

end
