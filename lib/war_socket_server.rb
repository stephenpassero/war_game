require 'socket'
require 'war_socket_server'
require_relative 'war_game'
require('pry')

class WarSocketServer
  def initialize
    @pending_clients = []
    @games = []
  end

  def port_number
    3001
  end

  def games
    @games
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = "Random Player")
    client = @server.accept_nonblock
    @pending_clients.push(client)
    if @pending_clients.size.odd?
      client.puts("Welcome! Waiting for other players to join...")
    else
      client.puts("Welcome! The war will begin shortly.")
    end
    # associate player and client
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible
    ready_to_play_value = ready_to_play?
    if @pending_clients.length.even? && ready_to_play_value
      @games.push(WarGame.new())
      @pending_clients.shift(2)
    end
    ready_to_play_value
  end

  def stop
    @server.close if @server
  end

  private
  def capture_output(client, delay=0.1)
    sleep(delay)
    output = ""
    output = client.read_nonblock(1000)
  rescue IO::WaitReadable
    output = "No Output Available"
  end

  def ready_to_play?
    client1 = @pending_clients[0]
    client1.puts("Are you ready to play?")
    if @pending_clients.length > 1
      client2 = @pending_clients[1]
      client2.puts("Are you ready to play?")
      if capture_output(client1) == "yes\n" && capture_output(client2) == "yes\n"
        return true
      else
        return false
      end
    end
    if capture_output(client1) == "yes"
      return true
    else
      return false
    end
  end
end
