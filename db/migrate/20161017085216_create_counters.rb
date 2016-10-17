class CreateCounters < ActiveRecord::Migration
  def change
    create_table :counters do |t|
      t.references :account, index: true, foreign_key: true
      t.references :utility, index: true, foreign_key: true
      t.float :value, default: 0.0
    end
  end
end
