class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

#  Rack::Attack.throttle('logins/ip', :limit => 3, :period => 600) do |req|
#    req.ip if req.post? && req.path == "/users/sign_in"
#  end


end
