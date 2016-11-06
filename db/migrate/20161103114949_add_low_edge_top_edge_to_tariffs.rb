class AddLowEdgeTopEdgeToTariffs < ActiveRecord::Migration
  def change
    add_column :tariffs, :low_edge, :float, default: 0.0
    add_column :tariffs, :top_edge, :float, default: 0.0
  end
end
