require("card")

class CardDeck
  def initialize()
    @ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"]
    @suits = ["Hearts", "Diamonds", "Clubs", "Spades"]
    @cards = []
  end

  def cards_left()
    52
  end

  def create_deck()
    @ranks.each do |rank|
      @suits.each do |suit|
        @cards.push(Card.new(rank, suit))
      end
    end
  end

  def list(index)
    @cards[index]
  end
end
