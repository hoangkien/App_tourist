class AddCompanyIdToTourguides < ActiveRecord::Migration
  def change
    add_column :tourguides, :company_id, :integer
  end
end
