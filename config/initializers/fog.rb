require 'fog-aws'

connection = Fog::Storage.new({
  :provider                 => 'AWS',
  :aws_secret_access_key    => ENV['AWS_SECRET_ACCESS_KEY'],
  :aws_access_key_id        => ENV['AWS_ACCESS_KEY_ID']
})