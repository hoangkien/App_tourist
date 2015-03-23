class AddImagesToTravellers < ActiveRecord::Migration
  def change
    add_column :travellers, :images, :string
  end
end
