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
    if @pending_clients.length.even?
      @games.push(WarGame.new())
      @pending_clients.shift(2)
    end
  end

  def stop
    @server.close if @server
  end
end
