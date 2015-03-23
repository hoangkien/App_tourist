class CreateTourguides < ActiveRecord::Migration
  def change
    create_table :tourguides do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.integer :device_id
      t.boolean :active

      t.timestamps null: false
    end
  end
end
