require 'socket'
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
    games_to_clients
  end

  def start
    @server = TCPServer.new(3001)
  end

  def nums_of_clients_in_a_game(index_of_game)
    games_to_clients.values[index_of_game].length
  end

  def num_of_games()
    games_to_clients.length
  end

  def accept_new_client(player_name = "Random Player")
    sleep(0.1)
    client = @server.accept_nonblock
    @pending_clients.push(client)
    if @pending_clients.length.odd?
      client.puts("Welcome! Waiting for other players to join...")
    else
      client.puts("Welcome! The war will begin shortly.")
    end
    # associate player and client
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible()
    if @pending_clients.length == 2
      game = WarGame.new()
      games_to_clients.store(game, @pending_clients.shift(2))
      game.start_game()
      return game
    end
  end

  def find_game(game_id)
    games_to_clients.keys[game_id]
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

  def player_cards_left(game, player)
    game.player_cards_left(player)
  end

  def run_round(game)
    result = game.start_round
    client1 = games_to_clients[game][0]
    client2 = games_to_clients[game][1]
    client1.puts(result)
    client2.puts(result)
    client1.puts("You have #{player_cards_left(game, game.player1)} cards left")
    client2.puts("You have #{player_cards_left(game, game.player2)} cards left")
  end

  def run_game(game)
    client1 = games_to_clients[game][0]
    client2 = games_to_clients[game][1]
    until game.winner do
      client1.puts("Are you ready to play your next card?")
      client2.puts("Are you ready to play your next card?")
      ready_to_play?(game)
        run_round_value = run_round(game)
        if run_round_value == "Player 1"
          game_over_player1 = "Game Over... Player 1 has won!"
          client1.puts("Game Over... Player 1 has won!")
          client2.puts("Game Over... Player 1 has won!")
          end_game(client1, client2)
          break
        elsif run_round_value == "Player 2"
          client1.puts("Game Over... Player 2 has won!")
          client2.puts("Game Over... Player 2 has won!")
          end_game(client1, client2)
          break
        end
      # Client is informed of round results in run_round
    end
    if game.winner
      client1.puts("Game Over... #{game.winner} has won!")
      client2.puts("Game Over... #{game.winner} has won!")
      client1.close
      client2.close
    end
  end

  def ready_to_play?(game)
    client1_output=""
    client2_output=""
    until client1_output == "yes\n" and client2_output == "yes\n" do
      if client1_output == ""
        client1_output = capture_output(game, 0)
      end
      if client2_output == ""
        client2_output = capture_output(game, 1)
      end
    end
    true
  end

  private
  def games_to_clients()
    @games_to_clients
  end

  def capture_output(game, desired_client, delay=0.1)
    sleep(delay)
    output = ""
    client = games_to_clients[game][desired_client]
    output = client.read_nonblock(1000)
  rescue IO::WaitReadable
    output = ""
  end
end
