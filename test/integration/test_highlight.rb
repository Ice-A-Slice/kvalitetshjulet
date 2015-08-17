require 'test_helper'

class High_Lights_test <ActionDispatch::IntegrationTest
	test "show a highlight" do 
		high_light = high_lights(:one)
		visit high_light_url(high_light)
        assert_equal high_light_path(high_light), current_path
		#within("#tes") do
		#assert has_content?("ssdfefss")
	#end
    assert page.has_content?(high_light.comment), "Did not find the high_light"
	#expect(page).to have_content 'Invalid email or password'
  end

    test "should get new school" do 
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
    end

    test "should have a search bar" do
    	visit schools_path
    	assert page.has_selector? '#DataTables_Table_0_filter'
    end

end