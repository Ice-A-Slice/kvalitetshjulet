require 'rails_helper'

RSpec.describe "event_types/index", :type => :view do
  before(:each) do
    assign(:event_types, [
      EventType.create!(
        :name => "Name",
        :color => "Color"
      ),
      EventType.create!(
        :name => "Name",
        :color => "Color"
      )
    ])
  end

  it "renders a list of event_types" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Color".to_s, :count => 2
  end
end
