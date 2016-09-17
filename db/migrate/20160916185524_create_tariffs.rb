class CreateTariffs < ActiveRecord::Migration
  def change
    create_table :tariffs do |t|
      t.references :category, index: true, foreign_key: true
      t.string :name
      t.decimal :value,      :precision => 10, :scale => 2, :null => false
      t.date :start_date

      t.timestamps null: false
    end
  end
end
