# Seeds

##
# Plans
p 'Seeding plans...'

p '... Awesome trial'
Plan.create! do |p|
  p.name = 'Awesome trial'
  p.price = 0
  p.trial = true
  p.user_limit = 30
end

p '... Small Company (10)'
Plan.create! do |p|
  p.name = 'Small Company (10)'
  p.price = 250
  p.user_limit = 10
end

p 'Seeding a user'
User.create! do |u|
  u.name = 'Thomas Klemm'
  u.build_owned_account(name: 'Twinbox')
  u.email = 'twinbox@tklemm.eu'
  u.password = 'twinbox123'
end
