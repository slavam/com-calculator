class AddOwnerIdLatLngToFlats < ActiveRecord::Migration
  def change
    add_column :flats, :lat, :float
    add_column :flats, :lng, :float
    add_reference :flats, :owner, index: true
    add_foreign_key :flats, :owners
  end
end
