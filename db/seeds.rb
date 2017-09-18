if false
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

users.each do |u|
  if u.id < 35 and u.id > 25
    user.friend_request(u)
  elsif u.id < 45 and u.id >= 35
    u.friend_request(user)
  end
end


5.times do
  users.each { |user| user.posts.create!(content:  Faker::Lorem.sentence(5)) }
end
end

################
# For Redis

if false
Post.includes(:user, :liked_users, :post_attachments).all.each do |post|
  post_attr = post.attributes
  post_attr["liked_user_ids"] = post.liked_user_ids
  post_attr["liked_user_names"] = post.liked_users.pluck(:username)

  user = post.user
  user_attr = { "username": user.username, "avatar_present?": user.avatar.present?, "avatar_url_thumb": user.avatar.url(:thumb), "fb_avatar": user.fb_avatar }
  post_attr["user"] = user_attr

  attachments_attr = post.post_attachments.map{|att| {"picture_url": att.picture_url} }
  post_attr["post_attachments"] = attachments_attr 

  $redis.zadd("user_#{post.user_id}_posts", post.updated_at.to_i, post_attr.to_json)
end

User.count.times do |i|
  $redis.del("user_#{i+1}_posts")
end

end


