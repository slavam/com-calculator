class AddCounterFieldsToUtilities < ActiveRecord::Migration
  def change
    add_column :utilities, :description_counter, :string
    add_column :utilities, :start_vailue_counter, :float
  end
end
