class AddWeekToEvents < ActiveRecord::Migration
  def change
    add_column :events, :week, :integer
  end
end
