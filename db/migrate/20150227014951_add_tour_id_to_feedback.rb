class AddTourIdToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :tour_id, :integer
  end
end
