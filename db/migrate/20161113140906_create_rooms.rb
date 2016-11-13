class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :n_room
      t.string :a_room
    end
  end
end
