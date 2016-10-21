class AddLastValueCounterToUtilities < ActiveRecord::Migration
  def change
    add_column :utilities, :last_value_counter, :float, default: 0.0
  end
end
