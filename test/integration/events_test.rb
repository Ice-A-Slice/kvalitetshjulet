require 'test_helper'
class Events_test <ActionDispatch::IntegrationTest

  test "Events path should have divs" do
    visit events_path
    assert page.has_selector? 'div'
  end

end