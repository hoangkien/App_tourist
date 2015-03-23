class CreateJoinTableTourTraveller < ActiveRecord::Migration
  def change
    create_join_table :tours, :travellers, id: false do |t|
      # t.index [:tour_id, :traveller_id]
      # t.index [:traveller_id, :tour_id]
      t.timestamps null: false
    end
  end
end
