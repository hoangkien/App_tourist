class AddImagesToTourguides < ActiveRecord::Migration
  def change
    add_column :tourguides, :images, :string
  end
end
