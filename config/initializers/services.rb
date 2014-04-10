class Services

  def self.user_service
    @@services ||= proxy_services
    @@services[:user_service]
  end

  def self.proxy_services
    opts = {
      database_url: ENV['OPENREDIS_URL'] || 'redis://localhost:6379'
    }

    transport = Barrister::RedisTransport.new 'user_service', opts
    client    = Barrister::Rails::Client.new transport

    { user_service: client.UserService }
  end

end
