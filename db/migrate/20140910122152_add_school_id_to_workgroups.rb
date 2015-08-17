class AddSchoolIdToWorkgroups < ActiveRecord::Migration
  def change
    add_column :workgroups, :school_id, :integer
  end
end
