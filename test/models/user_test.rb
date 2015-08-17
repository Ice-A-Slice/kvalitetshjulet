require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user attributes must not be empty" do
    user = User.new
    assert user.invalid?, "Empty user passed validation"
    assert user.errors[:name].any?, "User passed validation without name"
    assert user.errors[:email].any?, "User passed validation without email"
    assert user.errors[:user_type].any?, "User passed validation without user_type"
  end
end
