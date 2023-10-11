require_relative 'connection'

class Smalltable::Db
  def initialize(host: '127.0.0.1', port: 1337)
    @host = host
    @port = port
    @connection = Smalltable::Connection.new(host: @host, port: @port)
  end

  def insert(key, value)
    send_command("INSERT #{key} #{value}")
    hash_pair(key, value)
  end

  def find(key)
    send_command("FIND #{key}").first
  end

  def all
    result = send_command('ALL')

    result.filter_map do |pair|
      key_value = pair.split
      next unless key_value[1]
      hash_pair(key_value[0], key_value[1])
    end
  end

  def remove(key)
    send_command("REMOVE #{key}").first
    key
  end

  def update(key, value)
    send_command("UPDATE #{key} #{value}")
    hash_pair(key, value)
  end

  private

  def send_command(command)
    response = @connection.send(command)
    response.split("\n")
  end

  def hash_pair(key, value)
    { key => value }
  end
end
