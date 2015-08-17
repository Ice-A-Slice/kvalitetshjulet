class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :comment
      t.datetime :datetime
      t.references :user, index: true
      t.references :school, index: true

      t.timestamps
    end
  end
end
