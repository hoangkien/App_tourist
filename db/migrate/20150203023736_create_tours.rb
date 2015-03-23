class CreateTours < ActiveRecord::Migration
  def change
    create_table :tours do |t|
      t.string :name
      t.integer :number_of_member
      t.string :information

      t.timestamps null: false
    end
  end
end
