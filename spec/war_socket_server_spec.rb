
require 'socket'
require_relative '../lib/war_socket_server'

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
    @clients = []
    @server = WarSocketServer.new
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
    expect(@server.games_to_clients.count).to be 0
    client2 = MockWarSocketClient.new(@server.port_number)
    client2.provide_input("yes")
    client1.provide_input("yes")
    @server.accept_new_client("Player 2")
    @server.create_game_if_possible
    expect(@server.games_to_clients.count).to be 1
    client3 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client("Player 3")
    client3.provide_input("yes")
    expect(@server.games_to_clients.count).to be 1
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
    expect(@server.create_game_if_possible).to eq(false)
    client1.provide_input("yes")
    client2.provide_input("yes")
    expect(@server.create_game_if_possible).to eq(true)
  end

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
    expect(@server.games_to_clients.values[0].length).to eq(num_of_clients)
  end

  it "creates multiple games for more than 3 players" do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client("Player 1")
    client2 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client("Player 2")
    client2.provide_input("yes")
    client1.provide_input("yes")
    @server.create_game_if_possible
    client3 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client("Player 3")
    client4 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client("Player 4")
    client3.provide_input("yes")
    client4.provide_input("yes")
    @server.create_game_if_possible
    num_of_games = 2
    expect(@server.games_to_clients.length).to eq(num_of_games)
    client5 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client("Player 5")
    client5.provide_input("yes")
    client6 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client("Player 6")
    client6.provide_input("yes")
    @server.create_game_if_possible
    expect(expect(@server.games_to_clients.length).to eq(num_of_games + 1))
  end
end
