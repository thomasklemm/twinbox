class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.belongs_to :company
      t.integer :tweet_id
      t.text :text
      t.text :user_screen_name
      t.text :user_name

      t.timestamps
    end
    add_index :tweets, :company_id
  end
end
