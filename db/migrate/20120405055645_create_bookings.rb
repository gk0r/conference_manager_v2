class CreateBookings < ActiveRecord::Migration
  def up
    create_table :bookings do |t|
      t.string :user_id, :null => false
      t.string :conference_number_id, :null => false
      t.date :date, :null => false
      t.datetime :time_start, :null => false
      t.datetime :time_finish, :null => false
      t.text :note

      t.timestamps
    end
  end
  
  def down
    drop_table :bookings
  end
  
end
