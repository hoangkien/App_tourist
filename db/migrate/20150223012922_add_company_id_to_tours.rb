class AddCompanyIdToTours < ActiveRecord::Migration
  def change
    add_column :tours, :company_id, :integer
  end
end
