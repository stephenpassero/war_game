require("card")
require("pry")

class CardDeck
  attr_reader(:list_cards)

  def initialize()
    ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"]
    suits = ["Hearts", "Diamonds", "Clubs", "Spades"]
    @cards = []
    ranks.each do |rank|
      suits.each do |suit|
        @cards.push(Card.new(rank, suit))
      end
    end
    @list_cards = @cards
  end

  def cards_left()
    @cards.length
  end

  def shuffle!()
    @cards.sort_by {rand}
  end

  def play_top_card()
    @cards.shift()
  end

  def split_in_two()
    @cards.each_slice(@cards.length / 2)
  end
end
