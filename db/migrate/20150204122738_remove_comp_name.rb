class RemoveCompName < ActiveRecord::Migration
  def change
	remove_column :users, :comp_name
  end
end
