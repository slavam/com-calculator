class CreateRoomLocations < ActiveRecord::Migration
  def change
    create_table :room_locations do |t|
      t.references :house_location, index: true, foreign_key: true
      t.references :room, index: true, foreign_key: true
    end
  end
end
