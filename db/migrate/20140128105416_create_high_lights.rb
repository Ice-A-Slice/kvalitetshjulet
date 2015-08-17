class CreateHighLights < ActiveRecord::Migration
  def change
    create_table :high_lights do |t|
      t.integer :week
      t.integer :year
      t.integer :color
      t.text :comment
      t.references :user, index: true

      t.timestamps
    end
  end
end
