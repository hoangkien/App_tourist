class AddCodeToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :code, :string
  end
end
