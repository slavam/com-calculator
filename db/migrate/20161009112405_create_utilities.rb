class CreateUtilities < ActiveRecord::Migration
  def change
    create_table :utilities do |t|
      t.references :flat, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true
      t.references :tariff, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
