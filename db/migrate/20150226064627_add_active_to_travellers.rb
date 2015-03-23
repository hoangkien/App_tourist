class AddActiveToTravellers < ActiveRecord::Migration
  def change
    add_column :travellers, :active, :integer
  end
end
