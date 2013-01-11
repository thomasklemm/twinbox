class CreateTwitterAccounts < ActiveRecord::Migration
  def change
    create_table :twitter_accounts do |t|
      t.text :login
      t.text :uid
      t.text :token
      t.text :token_secret
      t.belongs_to :company

      t.timestamps
    end
    add_index :twitter_accounts, :company_id
  end
end
