require_relative("war_game")

game = WarGame.new()
game.start_game()
until game.winner() do
    if game.start_round() == "Game Over"
      break;
    else
      puts game.start_round()
    end
end
if game.player1.deck.cards_left < 4
  if(game.player1.deck.cards_left == 0)
    puts "Winner is Player 2"
  else
    puts "War! Player 1 didn't have enough cards to finish the war. Player 2 Wins!"
  end
elsif game.player2.deck.cards_left < 4
  if(game.player2.deck.cards_left == 0)
    puts "Winner is Player 1"
  else
    puts "War! Player 2 didn't have enough cards to finish the war. Player 1 Wins!"
  end
end
