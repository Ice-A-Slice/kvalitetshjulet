require 'test_helper'
class Principal::UsersTest < ActionDispatch::IntergrationTest

  /test "show a principal" do
    principal = users(:one)
    visit principal_users_url(principal)
    assert_equal high_light_path(high_light), current_path
    #within("#tes") do
    #assert has_content?("ssdfefss")
    #end
    assert page.has_content?(high_light.comment), "Did not find the high_light"
    #expect(page).to have_content 'Invalid email or password'
  end/

  /test "should get new school" do
    visit schools_path
    click_link "Lägg till skola"
    assert_equal new_school_path, current_path, "Wrong path"
  end

  test "should create a new school" do
    visit new_school_path
    fill_in "school[name]", with: 'Rudbeckskolan'
    select "Stockholms", from: "school[district]"
    click_button "Lägg till"
    assert page.has_content?("Rudbeckskolan")
  end/

  test "principal path should have divs" do
    visit principal_users_path
    assert page.has_content? 'Skapa en ny rektor'
  end

  test "principal path should have divs" do
    visit principal_users_path
    assert page.has_selector? 'div'
  end

end