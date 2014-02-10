class RedisTransport

  def initialize(list_name)
    @list_name = list_name
    @client = Redis.new
  end

  def request(message)
    # reply-to tells the server where we'll be listening
    request = {
      'reply_to' => 'reply-' + SecureRandom.uuid,
      'message'  => message
    }

    # insert our request at the head of the list
    @client.lpush(@list_name, JSON.generate(request))

    # pop last element off our list in a blocking fashion
    channel, response = @client.brpop(request['reply_to'], timeout=30)

    JSON.parse(response)['message']
  end
end

class UserService

  RETURN_MAPPINGS = {
    'create_user' => {
      'is_array' => false,
      'type' => User
    },
    'delete_user_by_id' => {
      'is_array' => false
    },
    'get_all_users' => {
      'is_array' => true,
      'type' => User
    },
    'get_user_by_id' => {
      'is_array' => false,
      'type' => User
    },
    'update_user_by_id' => {
      'is_array' => false,
      'type' => User
    }
  }

  def self.client
    proxy_service = lambda do
      config = YAML::load_file(File.join(Rails.root, 'config', 'services.yml'))['user_service']
      trans  = RedisTransport.new('user_service')
      client = Barrister::Client.new(trans)
      client.UserService
    end

    @@service ||= proxy_service.call()
  end

  def self.call(operation, *args)
    result = self.client.send operation, *args
    custom_type = RETURN_MAPPINGS[operation]['type']

    if custom_type
      self.cast(operation, result, custom_type)
    else
      result
    end
  end

  def self.cast(operation, result, klass)
    if RETURN_MAPPINGS[operation]['is_array']
      result.map { |hash| klass.new(hash) }
    else
      klass.new(result)
    end
  end
end
