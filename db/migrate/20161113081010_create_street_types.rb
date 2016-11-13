class CreateStreetTypes < ActiveRecord::Migration
  def change
    create_table :street_types do |t|
      t.string :name, null: false
      t.string :short_name
    end
  end
end
