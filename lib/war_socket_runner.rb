require 'socket'
require_relative 'war_socket_server'

server = WarSocketServer.new
server.start
loop do
  server.accept_new_client
  game = server.create_game_if_possible
  if game
    server.run_game(game)
  end

end
