class AddCompanyIdToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :company_id, :integer
  end
end
