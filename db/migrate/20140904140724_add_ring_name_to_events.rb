class AddRingNameToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ring_name, :string
  end
end
