Fabricator(:author) do
  twitter_id  813286
  name        'Barack Obama'
  screen_name 'BarackObama'
  location    'Washington DC, U.S.'
  description 'POTUS'
  url         'http://www.barackobama.com'
  verified    true
  created_at  { 2.months.ago }
  followers_count 10_000
  friends_count   5_000
  profile_image_url 'https://si0.twimg.com/profile_images/3221742532/5ceae8f2b72a1a8b012d2f5960fb46be_normal.jpeg'
end
