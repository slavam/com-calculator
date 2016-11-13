class CreateStreetLocations < ActiveRecord::Migration
  def change
    create_table :street_locations do |t|
      t.references :city, index: true, foreign_key: true
      t.string :name, null: false
      t.string :name2
      t.references :street_type, index: true, foreign_key: true
    end
  end
end
