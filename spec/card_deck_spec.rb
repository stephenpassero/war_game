require("rspec")
require("card_deck")

describe("#card_deck") do
  it("should contains 52 cards") do
    deck = CardDeck.new()
    expect(deck.cards_left()).to eq(52)
  end

  it("should be able to shuffle the deck") do
    deck = CardDeck.new()
    cards = deck.list_cards()
    expect(deck.shuffle!()).not_to eq(cards)
  end
end
