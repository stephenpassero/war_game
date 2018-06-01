require("./card")
require("pry")

class CardDeck
  attr_reader(:list_cards)

  def initialize(*arrOfCards)
    ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"]
    suits = ["Hearts", "Diamonds", "Clubs", "Spades"]
    if arrOfCards.length > 0
      @cards = arrOfCards[0]
    else
      @cards = []
      ranks.each do |rank|
        suits.each do |suit|
          @cards.push(Card.new(rank, suit))
        end
      end
    end
    @list_cards = @cards
  end

  def add(cards_to_add)
    cards_to_add.each do |card|
      @cards.push(card)
    end
  end

  def cards_left()
    @cards.length
  end

  def shuffle!()
    @cards.shuffle!
  end

  def play_top_card()
    @cards.shift()
  end

  def split_in_two()
    # returns an array containing two equal arrays
    @cards.each_slice(@cards.length / 2).to_a
  end
end
