module ApplicationHelper
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.referrer if request.get?
  end

  def add_record_to_redis(post)
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

  def remove_record_from_redis(post, updated_at = nil)
    updated_at ||= post.updated_at.to_i.to_s
    $redis.zremrangebyscore("user_#{post.user_id}_posts", updated_at, updated_at)
  end



end
