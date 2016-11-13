class CreateHouseLocations < ActiveRecord::Migration
  def change
    create_table :house_locations do |t|
      t.references :street_location, index: true, foreign_key: true
      t.references :house, index: true, foreign_key: true
      t.integer :zip_code
      t.integer :area_id
    end
  end
end
