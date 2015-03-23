class AddInformationToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :information, :text
  end
end
