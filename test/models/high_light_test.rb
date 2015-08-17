require 'test_helper'

class HighLightTest < ActiveSupport::TestCase
  test "high light attributes must not be empty" do
    hl = HighLight.new
    assert hl.invalid?, "Empty High Light passed validation"
    assert hl.errors[:week].any?, "High Light passed validation without week"
    assert hl.errors[:year].any?, "High Light passed validation without year"
    assert hl.errors[:color].any?, "High Light passed validation without color"
    assert hl.errors[:comment].any?, "High Light passed validation without comment"
    assert hl.errors[:user_id].any?, "High Light passed validation without user_id"
  end

  test "high light week number can only be int between 1 and 52" do

    hl0 = HighLight.new(:year => 2014,
                      :color => 1,
                      :comment => "highlight comment",
                      :user_id => 1)
    hl0.week = 0

    hl1 = HighLight.new(:year => 2014,
                        :color => 1,
                        :comment => "highlight comment",
                        :user_id => 1)
    hl1.week = 1
    assert hl1.valid?, "week number cant be 1"

    hl52 = HighLight.new(:year => 2014,
                         :color => 1,
                         :comment => "highlight comment",
                         :user_id => 1)
    hl52.week = 52
    assert hl52.valid?, "week number cant be 1"

    hl53 = HighLight.new(:year => 2014,
                         :color => 1,
                         :comment => "highlight comment",
                         :user_id => 1)
    hl53.week = 53
    assert hl53.invalid?, "can be 53"
  end
end

