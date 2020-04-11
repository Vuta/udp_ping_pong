require 'socket'
require 'timeout'

class UDPing
  PORT = 8080
  HOST = '127.0.0.1'

  attr_reader :client

  def initialize
    @client = UDPSocket.new
  end

  def run
    10.times do
      begin
        ping_pong.call
      rescue Timeout::Error
        puts 'Request timeout'
      end
    end
  end

  private

  def ping_message
    'ping'
  end

  def pong_message?(message)
    message.downcase == 'pong'
  end

  def ping_pong
    lambda do
      Timeout::timeout(1) do
        before = Time.now
        client.send(ping_message, 0, HOST, PORT)
        reply, _address = client.recvfrom(10)
        after = Time.now

        pong_message?(reply) ? (puts "RTT: #{after - before}") : (puts reply)
      end
    end
  end
end

UDPing.new.run
