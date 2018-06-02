require_relative("war_game")

game = WarGame.new()
game.start_game()
rounds = 0
until game.winner() do
  puts "Player 1 starting round #{rounds} with: #{game.player1.deck.cards_left} cards"
  puts "Player 2 starting round #{rounds} with #{game.player2.deck.cards_left} cards"
    result = game.start_round()
    if result == "Game Over"
      break;
    else
      puts result
      game.player1.deck.shuffle!
      game.player2.deck.shuffle!
      rounds += 1
    end
end
if game.player1.deck.cards_left < 4
  if(game.player1.deck.cards_left == 0)
    puts "Player 2 Wins!"
  else
    puts "War! Player 1 didn't have enough cards to finish the war. Player 2 Wins!"
  end
elsif game.player2.deck.cards_left < 4
  if(game.player2.deck.cards_left == 0)
    puts "Player 1 Wins!"
  else
    puts "War! Player 2 didn't have enough cards to finish the war. Player 1 Wins!"
  end
end
