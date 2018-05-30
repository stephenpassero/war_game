require("rspec")
require("card_deck")

describe("card_deck") do

  it("should contains 52 cards") do
    deck = CardDeck.new()
    expect(deck.cards_left()).to eq(52)
  end

  it("should be able to shuffle the deck") do
    deck = CardDeck.new()
    cards = deck.list_cards()
    expect(deck.shuffle!()).not_to eq(cards)
  end

  describe("#play_top_card") do
    it("should return the top card of the deck") do
      card_rank = 2
      deck = CardDeck.new()
      top_card = deck.play_top_card()
      expect(top_card.rank).to eq(card_rank)
    end

    it("should remove the card played from the deck") do
      deck = CardDeck.new()
      deck.play_top_card()
      expect(deck.cards_left()).to eq(51)
    end
  end
end
