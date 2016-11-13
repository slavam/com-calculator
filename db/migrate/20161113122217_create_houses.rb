class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      t.integer :n_house, null: false
      t.integer :f_house
      t.string  :a_house
      t.integer :d_house
    end
  end
end
