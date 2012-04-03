class CreateConferenceNumbers < ActiveRecord::Migration
  def change
    create_table :conference_numbers do |t|
      t.string :conference_number

      t.timestamps
    end
  end
end
