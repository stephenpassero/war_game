require("rspec")
require("card")

describe("#card") do
  it("returns its suit") do
    card_suit = "spades"
    card = Card.new(card_suit, "")
    expect(card.suit()).to eq("spades")
  end

  it("returns its value") do
    card_value = "Jack"
    card = Card.new("", card_value)
    expect(card.value()).to eq("Jack")
  end
end
