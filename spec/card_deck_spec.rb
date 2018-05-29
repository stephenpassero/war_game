require("rspec")
require("card_deck")

describe("#card_deck") do
  it("should contains 52 cards") do
    deck = CardDeck.new()
    expect(deck.cards_left()).to eq(52)
  end

  it("should be able to generate a deck and list a card in the deck") do
    deck = CardDeck.new()
    index = 0
    deck.create_deck()
    card1 = deck.list(index)
    expect(card1.class).to eq(Card)
  end
end
