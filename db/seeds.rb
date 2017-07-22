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
send_request = users[2..50]
send_request.each do |u|
  if u.id < 20
    u.friend_request(user)
    user.confirm_request(u)
  elsif u.id < 30
    user.friend_request(u)
  elsif u.id < 40
    u.friend_request(user)
  end
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.posts.create!(content: content) }
end
