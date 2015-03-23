class AddCompanyIdToTravellers < ActiveRecord::Migration
  def change
    add_column :travellers, :company_id, :integer
  end
end
