if Rails.env.development?
    $redis = Redis::Namespace.new("fakebook", :redis => Redis.new(password: ENV["redis_pw"]))
elsif Rails.env.production?
    #uri =  URI.parse(ENV["REDISTOGO_URL"])
    $redis = Redis::Namespace.new("fakebook", :redis => Redis.new(url: ENV["redis_url"]))
end
