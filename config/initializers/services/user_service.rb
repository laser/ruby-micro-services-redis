class UserService

  def self.instance
    @@instance ||= create
    @@instance.UserService
  end

  def self.create
    Barrister::Rails::Client.new(Barrister::RedisTransport.new('foo_bar', database_url: ENV['OPENREDIS_URL'] || 'redis://localhost:6379'))
  end

end
