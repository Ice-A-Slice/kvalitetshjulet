class CreateUserWorkgroups < ActiveRecord::Migration
  def change
    create_table :user_workgroups do |t|
      t.integer :user_id
      t.integer :workgroup_id

      t.timestamps
    end
  end
end
