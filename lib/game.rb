require("pry")
require("card_deck")
require("player")

class Game
  def initialize()
    @cardValues = {1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9, 10 => 10, "J" => 11, "Q" => 12, "K" => 13, "A" => 14}
    @deck = CardDeck.new()
    @middle_of_table = []
    @player1 = Player.new()
    @player2 = Player.new()
  end

  # def create_new_deck()
  #   deck = CardDeck.new()
  # end

  def start_round()
    two_decks = @deck.split_in_two()
    @player1.deck = CardDeck.new(two_decks[0])
    @player2.deck = CardDeck.new(two_decks[1])
    @middle_of_table.push(@player1.play_top_card())
    @middle_of_table.push(@player2.play_top_card())
    judge(@middle_of_table[0], @middle_of_table[1])
  end

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
      @player1.deck.add(@middle_of_table)
      @middle_of_table.clear()
      return card1
    elsif card2_value > card1_value
      @player2.deck.add(@middle_of_table)
      @middle_of_table.clear()
      return card2
    end
  end
end
