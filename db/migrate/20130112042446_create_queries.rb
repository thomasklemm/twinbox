class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.text :version
      t.text :term
      t.belongs_to :company
      t.belongs_to :twitter_account
      t.datetime :last_scheduled_at
      t.datetime :last_performed_at
      t.integer :max_tweet_id

      t.timestamps
    end
    add_index :queries, :company_id
    add_index :queries, :twitter_account_id
  end
end
