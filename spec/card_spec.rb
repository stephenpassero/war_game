require("rspec")
require("card")

describe("#card") do
  it("returns its value") do
    card_rank = "J"
    card = Card.new(card_rank, "")
    expect(card.rank()).to eq("J")
  end

  it("returns its value") do
    card_suit = "Spades"
    card = Card.new("", card_suit)
    expect(card.suit()).to eq("Spades")
  end
end
