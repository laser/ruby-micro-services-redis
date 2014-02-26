class UserService

  def self.instance
    @@instance ||= create
    @@instance.UserService
  end

  def self.create
    Barrister::Rails::Client.new(Barrister::RedisTransport.new(ENV['OPENREDIS_URL'] || 'redis://localhost:6379', 'foo_bar'))
  end

end
