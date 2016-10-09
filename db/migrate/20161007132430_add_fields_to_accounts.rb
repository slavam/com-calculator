class AddFieldsToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :start_date, :date
    add_column :accounts, :stop_date, :date
    add_column :accounts, :total, :decimal, :precision => 10, :scale => 2
    add_reference :accounts, :user, index: true
    add_foreign_key :accounts, :users
    add_reference :accounts, :flat, index: true
    add_foreign_key :accounts, :flats
  end
end
