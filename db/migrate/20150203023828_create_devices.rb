class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.boolean :status
      t.string :lat
      t.string :lng

      t.timestamps null: false
    end
  end
end
