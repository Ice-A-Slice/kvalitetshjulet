class AddFileToEvents < ActiveRecord::Migration
  def change
    add_column :events, :file, :string
  end
end
