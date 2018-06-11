require 'socket'
require 'pry'

should_connect = true

while should_connect do

  begin
    server = TCPSocket.new("localhost", 3001)
    puts server.gets
    while true
      puts server.gets
      answer = "yes\n"
      until answer == "yes\n"
        answer = gets.downcase
      end
      server.puts answer
      text = server.gets
      if text == "Game Over... Player 1 has won!" || text == "Game Over... Player 2 has won!"
        should_connect = false
        break;
      end
      puts "Waiting for opponent's response..."
      puts text
      puts server.gets
    end

rescue Errno::ECONNREFUSED
  puts "Waiting for server to arrive..."
  sleep (3)

rescue EOFError
  puts "Game over!"
  should_connect = false

rescue Errno::ECONNRESET
  should_connect = false;
end
end
