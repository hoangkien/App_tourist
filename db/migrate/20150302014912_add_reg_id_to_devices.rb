class AddRegIdToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :reg_id, :string
  end
end
