Fabricator(:owner, from: :user) do
  name 'Thomas Owner'
  email 'twinboxowner@tklemm.eu'
  password 'twinbox123'

  after_build { |user| user.owned_account = Fabricate.build(:account) }

  # # Owner has clicked confirmation link by default
  # transient :unconfirmed
  # after_create { |user| user.confirm! unless user.unconfirmed }
end
