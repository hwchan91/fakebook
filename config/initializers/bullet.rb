if defined? Bullet
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.add_whitelist :type => :unused_eager_loading, :class_name => "Post", :association => :post_attachments
end