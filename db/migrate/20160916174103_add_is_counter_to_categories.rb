class AddIsCounterToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :is_counter, :boolean, default: false
  end
end
