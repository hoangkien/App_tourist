class CreateTravellers < ActiveRecord::Migration
  def change
    create_table :travellers do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.integer :device_id

      t.timestamps null: false
    end
  end
end
