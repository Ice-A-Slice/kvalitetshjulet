require 'test_helper'

class SchoolTest < ActiveSupport::TestCase
  test "school attributes must not be empty" do
    school = School.new
    assert school.invalid?, "Empty school passed validation"
    assert school.errors[:name].any?, "School passed validation without name"
  end
end
