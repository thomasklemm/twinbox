class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.belongs_to :company
      t.integer :tweet_id, limit: 8 # postgres bigint
      t.text :text
      t.text :user_screen_name
      t.text :user_name
      t.text :user_image_url

      t.timestamps
    end
    add_index :tweets, :company_id
  end
end
