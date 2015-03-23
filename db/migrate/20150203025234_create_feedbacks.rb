class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :quantiy_service
      t.string :comment
      t.integer :traveller_id

      t.timestamps null: false
    end
  end
end
