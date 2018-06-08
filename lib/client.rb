require 'socket'

should_connect = true

while should_connect do

  begin
    server = TCPSocket.new("localhost", 3001)
    puts server.gets
    puts server.gets

    def capture_output(source)
      sleep(0.1)
      return source.read_nonblock(1000) # not gets which blocks
    rescue IO::WaitReadable
      return nil
    end

    loop do
      output = server.gets
      if output
        puts output
      end

      # input = capture_output(STDIN)
      answer = ''
      until answer == "yes\n"
        # server.puts(input)
        answer =  gets
      end
      server.puts answer
    end


  rescue Errno::ECONNREFUSED
    puts "Waiting for server to arrive..."
    sleep (3)

  rescue EOFError
    puts "Game over!"
    should_connect = false
  end
end
