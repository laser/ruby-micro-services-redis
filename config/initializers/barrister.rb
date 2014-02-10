module Barrister

  class RedisTransport

    def initialize(list_name, database_url)
      @list_name = list_name
      @client = Redis.connect url: database_url
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

end
