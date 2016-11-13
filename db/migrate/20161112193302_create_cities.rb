class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name, null: false
      t.string :name2
      t.integer :id_parent
      t.integer :last_erc_code
      t.references :city_type, index: true, foreign_key: true
      t.integer :code_koatuu
    end
  end
end
