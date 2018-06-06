require_relative("card_deck")
require("pry")

class Player
  attr_accessor(:deck)

  def initialize()
    @deck = CardDeck.new([]);
    @discard_pile = []
  end

  def put_in_discard(card)
    @discard_pile.push(card)
  end

  def discard_pile()
    @discard_pile
  end

  def play_top_card()
    @deck.play_top_card
  end

  def add_to_hand(arr_of_cards)
    @deck.add(arr_of_cards)
  end

  def set_hand(arr_of_cards)
    @deck = CardDeck.new(arr_of_cards)
  end

  def cards_left
    @deck.cards_left
  end
end
