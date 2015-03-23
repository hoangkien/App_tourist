class CreateGcmRegistration < ActiveRecord::Migration
  def change
    create_table :gcm_registrations do |t|
      t.string :regID
      t.integer :active
    end
  end
end
