class Card
  attr_reader(:suit, :value)
  def initialize(card_suit, card_value)
    @suit = card_suit
    @value = card_value
  end
end
