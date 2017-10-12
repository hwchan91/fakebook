if Rails.env.development?
    Sidekiq.configure_server do |config|
        config.redis = { url: 'redis://localhost:6379', password: ENV['redis_pw'] }
    end

    Sidekiq.configure_client do |config|
        config.redis = { url: 'redis://localhost:6379', password: ENV['redis_pw'] }
    end
elsif Rails.env.production?
    Sidekiq.configure_server do |config|
        config.redis = { url: ENV['redis_url'] }
    end

    Sidekiq.configure_client do |config|
        config.redis = { url: ENV['redis_url'] }
    end
end