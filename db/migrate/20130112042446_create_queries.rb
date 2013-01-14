class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.text :query_type
      t.text :term
      t.belongs_to :company
      t.belongs_to :twitter_account
      t.integer :max_tweet_id, limit: 8 # postgres bigint

      t.timestamps
    end
    add_index :queries, :company_id
    add_index :queries, :twitter_account_id
  end
end
