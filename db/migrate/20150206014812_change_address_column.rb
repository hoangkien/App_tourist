class ChangeAddressColumn < ActiveRecord::Migration
  def change
    change_column :companies, :address, :text
    change_column :users, :address, :text
    change_column :travellers, :address, :text
    change_column :tourguides, :address, :text
  end
end
