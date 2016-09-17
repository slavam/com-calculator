class AddUnitToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :unit, :string
  end
end
