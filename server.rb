require 'socket'

class UDPong
  PORT = 8080
  HOST = '127.0.0.1'

  attr_reader :server

  def initialize
    @server = UDPSocket.new
  end

  def run 
    server.bind(HOST, PORT)

    puts 'Server is ready!'

    loop do
      message, addr = server.recvfrom(10)
      client_address = addr[3]
      client_port = addr[1]

      server.send(reply_message, 0, client_address, client_port) if ping_message?(message)
    end
  end

  private

  def reply_message
    'pong'
  end

  def ping_message?(message)
    message.downcase == 'ping'
  end
end

UDPong.new.run
