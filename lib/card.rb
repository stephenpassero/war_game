class Card
  attr_reader(:suit, :rank)
  def initialize(card_rank, card_suit)
    @rank = card_rank
    @suit = card_suit
  end
end
