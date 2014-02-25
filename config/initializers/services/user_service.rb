class UserService
  config = YAML::load_file(File.join(Rails.root, 'config', 'redis.yml'))['default']

  @@instance = Barrister::Rails::Client.new(Barrister::Transports::Redis.new(config['list_name'], ENV['OPENREDIS_URL'] || config['database_url']))

  def self.instance
    @@instance.UserService
  end
end
