require("pry")

class Game
  def initialize()
    @cardValues = {1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9, 10 => 10, "J" => 11, "Q" => 12, "K" => 13, "A" => 14, }
  end

  def distribute_deck(first_player, second_player, deck_to_distribute)
    two_decks = deck_to_distribute.split_in_two()
    first_player.deck = CardDeck.new(two_decks[0])
    second_player.deck = CardDeck.new(two_decks[1])
  end

  def judge(card1, card2)
    card1_value = @cardValues.fetch(card1.rank)
    card2_value = @cardValues.fetch(card2.rank)
    if card1_value > card2_value
      return card1
    elsif card2_value > card1_value
      return card2
    end
  end
end
