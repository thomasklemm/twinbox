Fabricator(:tweet) do
  # Tweet fields
  twitter_id 266031293945503744
  text 'Four more years. http://t.co/bAJE6Vom'
  created_at { 1.month.ago }
  in_reply_to_status_id nil
  in_reply_to_user_id nil

  # Embeds author
  author { Fabricate.build(:author) }
end
