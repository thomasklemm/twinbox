Fabricator(:account) do
  name 'Twinbox'
  after_build { |account| account.plan = Fabricate.build(:plan) }
end
