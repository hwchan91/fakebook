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
send_request = users[2..50]
send_request.each do |u|
  u.friend(user)
  user.confirm(u)
end
