class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :utilities, :start_vailue_counter, :start_value_counter
  end
end
