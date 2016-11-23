class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.integer :code_erc, null: false
      t.string  :full_name
      t.references :room_location, index: true, foreign_key: true
      t.references :city, index: true, foreign_key: true
    end
  end
end
