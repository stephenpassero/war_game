
require 'socket'
require_relative '../lib/war_socket_server'
require_relative '../lib/card'

class MockWarSocketClient
  attr_reader :socket
  attr_reader :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay=0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ""
  end

  def close
    @socket.close if @socket
  end
end

describe WarSocketServer do
  before(:each) do
    @server = WarSocketServer.new
    @clients = []
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  it "is not listening on a port before it is started"  do
    expect {MockWarSocketClient.new(@server.port_number)}.to raise_error(Errno::ECONNREFUSED)
  end

  it "accepts new clients and starts a game if possible" do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client("Player 1")
    @server.create_game_if_possible
    expect(@server.num_of_games).to be 0
    client2 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client("Player 2")
    client2.provide_input("yes")
    client1.provide_input("yes")
    @server.create_game_if_possible
    expect(@server.num_of_games).to be 1
    client3 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client("Player 3")
    client3.provide_input("yes")
    expect(@server.num_of_games).to be 1
  end

  it "gives each player a response when they join" do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client("Player 1")
    expect(client1.capture_output).to eq("Welcome! Waiting for other players to join...\n")
    client2 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client("Player 2")
    expect(client2.capture_output).to eq("Welcome! The war will begin shortly.\n")
  end

  it "doesn't start the round until both players are ready" do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client("Player 1")
    client2 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client("Player 2")
    expect(@server.create_game_if_possible).to be_falsey()
    client1.provide_input("yes")
    client2.provide_input("yes")
    expect(@server.create_game_if_possible).to be_truthy()
  end
  # To-do: Test this without breaking encapsulation
  it "assigns a game to two clients" do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client("Player 1")
    client2 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client("Player 2")
    client2.provide_input("yes")
    client1.provide_input("yes")
    @server.create_game_if_possible
    num_of_clients = 2
    game_index = 0
    expect(@server.nums_of_clients_in_a_game(game_index)).to eq(num_of_clients)
  end

  context "war_socket_server" do
    before(:each) do
      @server.start
      client1 = MockWarSocketClient.new(@server.port_number)
      @server.accept_new_client("Player 1")
      client2 = MockWarSocketClient.new(@server.port_number)
      @server.accept_new_client("Player 2")
      client2.provide_input("yes")
      client1.provide_input("yes")
      @clients.push(client1, client2)
    end
    it "creates multiple games for more than 3 players" do
      @server.create_game_if_possible
      client3 = MockWarSocketClient.new(@server.port_number)
      @server.accept_new_client("Player 3")
      client4 = MockWarSocketClient.new(@server.port_number)
      @server.accept_new_client("Player 4")
      client3.provide_input("yes")
      client4.provide_input("yes")
      @server.create_game_if_possible
      expect(@server.num_of_games).to eq (2)
    end

    it "returns the output of each round" do
      @server.create_game_if_possible
      game_id = 0
      card1 = Card.new("J", "Clubs")
      card2 = Card.new(9, "Hearts")
      game = @server.find_game(game_id)
      @server.set_player_hand(game, "player1", [card1])
      @server.set_player_hand(game, "player2", [card2])
      @server.run_round(game)
      client1_output = @clients[0].capture_output()
      client2_output = @clients[1].capture_output()
      expect(client1_output).to include("Player 1 took a 9 of Hearts with a J of Clubs")
      expect(client2_output).to include("Player 1 took a 9 of Hearts with a J of Clubs")
    end

    it "can run multiple rounds" do
      @server.create_game_if_possible
      game_id = 0
      card1 = Card.new("J", "Clubs")
      card2 = Card.new("K", "Spades")
      card3 = Card.new(10, "Diamonds")
      card4 = Card.new("Q", "Hearts")
      game = @server.find_game(game_id)
      @server.set_player_hand(game, "player1", [card1, card2])
      @server.set_player_hand(game, "player2", [card3, card4])
      @server.run_round(game)
      @server.run_round(game)
      client1_output = @clients[0].capture_output()
      client2_output = @clients[1].capture_output()
      expect(client1_output).to include("Player 1 took a 10 of Diamonds with a J of Clubs")
      expect(client1_output).to include("Player 1 took a Q of Hearts with a K of Spades")
      expect(client2_output).to include("Player 1 took a 10 of Diamonds with a J of Clubs")
      expect(client2_output).to include("Player 1 took a Q of Hearts with a K of Spades")
    end

    it "#ready_to_play should remember each client's response" do
      #doesn't really test this. Need to make a thread to truely test it.
      @server.create_game_if_possible
      client3 = MockWarSocketClient.new(@server.port_number)
      @server.accept_new_client("Player 3")
      client4 = MockWarSocketClient.new(@server.port_number)
      @server.accept_new_client("Player 4")
      @clients.push(client3, client4)
      client3.provide_input("yes")
      sleep(0.2)
      client4.provide_input("yes")
      game = @server.create_game_if_possible
      expect(@server.ready_to_play?(game)).to eq(true)
    end
  end
end
