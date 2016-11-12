class CreateCityTypes < ActiveRecord::Migration
  def change
    create_table :city_types do |t|
      t.string :name
      t.string :short_name
    end
  end
end
