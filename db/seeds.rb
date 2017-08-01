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

(0..49).each do |i|
  (0..19).each do |j|
    users[i].friend_request(users[i+j+1])
    users[i+j+1].confirm_request(users[i])
  end
end

#users.each do |u|
#  if u.id < 35 and u.id > 25
#    user.friend_request(u)
#  elsif u.id < 45
#    u.friend_request(user)
#  end
#end




5.times do
  users.each { |user| user.posts.create!(content:  Faker::Lorem.sentence(5)) }
end
