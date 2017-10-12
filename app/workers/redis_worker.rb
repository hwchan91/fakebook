class RedisWorker
  include Sidekiq::Worker 

  def perform(id)
    newest = $redis.lrange("newest_post_ids", 0, -1)
    newest.each do |id|
      post = Post.find(id)
      post_attr = post.attributes
      post_attr["liked_user_ids"] = post.liked_user_ids
      post_attr["liked_user_names"] = post.liked_names
  
      user = post.user
      user_attr = { "username": user.username, "avatar_present?": user.avatar.present?, "avatar_url_thumb": user.avatar.url(:thumb), "fb_avatar": user.fb_avatar }
      post_attr["user"] = user_attr
  
      attachments_attr = post.post_attachments.map{|att| {"picture_url": att.picture_url} }
      post_attr["post_attachments"] = attachments_attr
      $redis.zremrangebyscore("newest_posts", post.id, post.id)
      $redis.zadd("newest_posts", post.id, post_attr.to_json)
    end
    $redis.zremrangebyrank("newest_posts", "0", "-101")
  end
end
