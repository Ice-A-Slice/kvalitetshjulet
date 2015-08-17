class CreateSchoolUsers < ActiveRecord::Migration
  def change
    create_table :school_users do |t|
      t.references :user, index: true
      t.references :school, index: true

      t.timestamps
    end
  end
end
