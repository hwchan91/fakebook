$redis = Redis::Namespace.new("fakebook", :redis => Redis.new(url: ENV["redis_url"]))