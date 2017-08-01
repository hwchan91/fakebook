User.create!(username:  "Example User",
             email: "example@mail.com",
             password:              "password")

99.times do |n|
  username  = Faker::Name.name
  email = "example-#{n+1}@mail.com"
  password = "password"
  user = User.create!(username:  username,
               email: email,
               password:              password)
end

user = User.first
users = User.all

users.each do |u|
  20.times do
    u.friend_request(users[i+1])
    users[i+1].confirm_request(u)
  end
  if u.id < 30 and u.id > 21
    user.friend_request(u)
  elsif u.id < 40
    u.friend_request(user)
  end
end



50.times do
  users.each { |user| user.posts.create!(content:  Faker::Lorem.sentence(5)) }
end
