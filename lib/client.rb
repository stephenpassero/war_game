require 'socket'
require 'pry'

should_connect = true

while should_connect do

  begin
    server = TCPSocket.new("localhost", 3001)
    puts server.gets
    while true
      puts server.gets
      answer = ''
      until answer == "yes\n"
        answer = gets.downcase
      end
      server.puts answer
      puts server.gets
      puts server.gets
    end

  rescue Errno::ECONNREFUSED
    puts "Waiting for server to arrive..."
    sleep (3)

  rescue EOFError
    puts "Game over!"
    should_connect = false
  end
end
