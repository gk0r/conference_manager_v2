class CreateConferenceNumbers < ActiveRecord::Migration
  def up
    create_table :conference_numbers do |t|
      t.string :conference_number

      t.timestamps
    end
  end
  
  def down
    drop_table :conference_numbers
  end
end
