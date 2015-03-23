class AddCompanyIdToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :company_id, :integer
  end
end
