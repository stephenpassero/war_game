require("card_deck")

class Player
  attr_accessor(:deck)

  def initialize()
    @deck = [];
    @discard_pile = []
  end

  def put_in_discard(card)
    @discard_pile.push(card)
  end

  def discard_pile()
    @discard_pile
  end

end
