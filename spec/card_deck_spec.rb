require("rspec")
require("card_deck")

describe("#card_deck") do
  it("should contains 52 cards") do
    deck = CardDeck.new()
    expect(deck.cards_left()).to eq(52)
  end

  it("should be able to generate a deck and list a cardC in the deck") do
    deck = CardDeck.new()
    index = 0
    cards = deck.list_cards()
    expect(cards[index].class).to eq(Card)
  end
end
