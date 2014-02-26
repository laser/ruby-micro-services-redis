class UserService

  def self.instance
    @@instance ||= create
    @@instance.UserService
  end

  def self.create
    config = YAML::load_file(File.join(Rails.root, 'config', 'redis.yml'))['default']
    Barrister::Rails::Client.new(Barrister::Transports::Redis.new(config['list_name'], ENV['OPENREDIS_URL'] || config['database_url']))
  end

end
