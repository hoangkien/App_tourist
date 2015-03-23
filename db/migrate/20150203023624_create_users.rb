class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :account
      t.string :password
      t.string :name
      t.string :address
      t.string :group
      t.string :comp_name

      t.timestamps null: false
    end
  end
end
