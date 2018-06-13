require 'socket'
require 'pry'

should_connect = true

while should_connect do

  begin
    server = TCPSocket.new("localhost", 3001)
    # Gets the waiting for other players input
    puts server.gets
    loop do
      puts server.gets # Gets the are you ready to play your next card prompt
      answer = "yes\n"
      until answer == "yes\n"
        answer = gets.downcase
      end
      server.puts answer
      round_results = server.gets # Gets the round's results
      if round_results == "Game Over... Player 1 has won!" || round_results == "Game Over... Player 2 has won!"
        should_connect = false
        break;
      end
      puts "Waiting for opponent's response..."
      puts round_results
      puts server.gets # Gets how many cards you have left
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
