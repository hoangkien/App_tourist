class CreateJoinTableTourTourguide < ActiveRecord::Migration
  def change
    create_join_table :tours, :tourguides, id: false do |t|
      # t.index [:tour_id, :tourguide_id]
      # t.index [:tourguide_id, :tour_id]\
      t.timestamps null: false
    end
  end
end
