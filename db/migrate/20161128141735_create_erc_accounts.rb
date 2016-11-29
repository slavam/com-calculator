class CreateErcAccounts < ActiveRecord::Migration
  def change
    create_table :erc_accounts do |t|
      t.references :owner, index: true, foreign_key: true
      t.integer :firm_id
      t.string :bankbook
    end
  end
end
