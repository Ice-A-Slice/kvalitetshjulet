class AddDotColorToEvents < ActiveRecord::Migration
  def change
    add_column :events, :dot_color, :string
  end
end
