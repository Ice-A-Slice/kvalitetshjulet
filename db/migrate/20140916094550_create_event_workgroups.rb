class CreateEventWorkgroups < ActiveRecord::Migration
  def change
    create_table :event_workgroups do |t|
      t.integer :event_id
      t.integer :workgroup_id

      t.timestamps
    end
  end
end
