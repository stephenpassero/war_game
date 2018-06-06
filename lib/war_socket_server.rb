require 'socket'
require 'war_socket_server'
require_relative 'war_game'
require('pry')

class WarSocketServer
  def initialize
    @pending_clients = []
    @games_to_clients = {}
  end

  def port_number
    3001
  end

  def games_to_clients
    @games_to_clients
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def nums_of_clients_in_a_game(index_of_game)
    games_to_clients.values[index_of_game].length
  end

  def num_of_games()
    games_to_clients.length
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

  def create_game_if_possible()
    # client1 = @pending_clients[0]
    # client2 = @pending_clients[1]
    # client1.puts("Are you ready to commence?")
    # client2.puts("Are you ready to commence?")
    if @pending_clients.length == 2 && ready_to_play?(@pending_clients[0], @pending_clients[1])
      game = WarGame.new()
      @games_to_clients.store(game, @pending_clients.shift(2))
      game.start_game()
      return game
    end
    false
  end

  def find_game(game_id)
    @games_to_clients.keys[game_id]
  end

  def stop
    @server.close if @server
  end

  def set_player_hand(game, player, arr_of_cards)
    if player == "player1"
      game.player1.set_hand(arr_of_cards)
    else
      game.player2.set_hand(arr_of_cards)
    end
  end

  def run_round(game)
    result = game.start_round
    players = @games_to_clients.fetch(game)
    players.each {|player| player.puts(result)}
  end

  def run_game(game)
    client1 = @games_to_clients[game][0]
    client2 = @games_to_clients[game][1]
    until game.winner do
      client1.puts("Are you ready to commence?")
      client2.puts("Are you ready to commence?")
      if ready_to_play?(client1, client2)
        run_round(game)
      end
    end
    end_game(game)
  end

  private
  def capture_output(client, delay=0.1)
    sleep(delay)
    output = ""
    output = client.read_nonblock(1000)
  rescue IO::WaitReadable
    output = "No Output Available"
  end

  def ready_to_play?(client1, client2)
    client1_output = capture_output(client1)
    client2_output = capture_output(client2)
    if client1_output == "yes\n" && client2_output == "yes\n"
      return true
    else
      return false
    end
  end
end
