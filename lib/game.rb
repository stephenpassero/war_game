require("pry")
require("card_deck")
require("player")

class Game
  attr_reader :player1, :player2

  def initialize()
    @cardValues = {1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9, 10 => 10, "J" => 11, "Q" => 12, "K" => 13, "A" => 14}
    @deck = CardDeck.new()
    @player1 = Player.new()
    @player2 = Player.new()
  end

  def start_game
    distribute_deck(@player1, @player2, @deck)
  end

  def start_round()
    judge(@player1.play_top_card(), @player2.play_top_card())
  end

  private

  def distribute_deck(first_player, second_player, deck_to_distribute)
    deck_to_distribute.shuffle!()
    two_decks = deck_to_distribute.split_in_two()
    first_player.deck = CardDeck.new(two_decks[0])
    second_player.deck = CardDeck.new(two_decks[1])
  end

  def judge(card1, card2)
    card1_value = @cardValues.fetch(card1.rank)
    card2_value = @cardValues.fetch(card2.rank)
    if card1_value > card2_value
      @player1.deck.add([card1, card2])
      return card1
    elsif card2_value > card1_value
      @player2.deck.add([card1, card2])
      return card2
    end
  end
end
