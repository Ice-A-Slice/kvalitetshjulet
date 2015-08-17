class AddFileToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :file, :string
  end
end
