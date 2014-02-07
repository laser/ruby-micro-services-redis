class UserService
  def self.client
    proxy_service = lambda do
      trans  = Barrister::HttpTransport.new("http://localhost:3001/user_service")
      client = Barrister::Client.new(trans)
      client.UserService
    end

    @@service ||= proxy_service.call()
  end
end
