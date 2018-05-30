require("rspec")
require("player")

describe("#player") do
  it("should have a deck of cards") do
    player = Player.new()
    expect(player.deck).not_to eq(nil)
  end

  it("should be able to put cards in a discard pile") do
    player = Player.new()
    card = Card.new("J", "Clubs")
    player.put_in_discard(card)
    expect(player.discard_pile).to eq([card])
  end
end
