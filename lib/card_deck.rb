require("card")

class CardDeck
  attr_reader(:cards_left, :list_cards)

  def initialize()
    ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"]
    suits = ["Hearts", "Diamonds", "Clubs", "Spades"]
    @cards = []
    ranks.each do |rank|
      suits.each do |suit|
        @cards.push(Card.new(rank, suit))
      end
    end
    @cards_left = @cards.length
    @list_cards = @cards
  end
end
