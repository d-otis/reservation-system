class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.text :note
      t.integer :user_id

      t.timestamps
    end
  end
end
