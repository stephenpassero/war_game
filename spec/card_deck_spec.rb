require("rspec")
require("card_deck")

describe("#card_deck") do
  it("should contains 52 cards") do
    deck = CardDeck.new()
    expect(deck.cards_left()).to eq(52)
  end
end
