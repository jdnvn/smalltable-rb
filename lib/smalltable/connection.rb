require 'socket'

class Smalltable::Connection
  def initialize(host:, port:)
    @host = host
    @port = port
    @socket = TCPSocket.open(host, port)
  rescue Errno::ECONNREFUSED => e
    raise 'No Smalltable server is running on that host and port'
  end

  def send(command)
    @socket.write(command)
    @socket.recv(1024)
  end
end

# Add a query result struct? that has the parsed response and whether it was a success for a failure
# parses the response according to the command?
