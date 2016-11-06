class AddIsVariableTariffToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :is_variable_tariff, :boolean, default: false
  end
end
