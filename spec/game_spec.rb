require("rspec")
require("game")

describe("#game") do
  # it("should be able to create a new deck") do
  #   game = Game.new()
  #   deck = game.create_new_deck()
  #   expect(deck.cards_left).to eq(52)
  # end

  it("should be able to split up the deck between both players") do
    game = Game.new()
    player1 = Player.new()
    player2 = Player.new()
    deck = CardDeck.new()
    game.distribute_deck(player1, player2, deck)
    expect(player1.deck.cards_left).to eq(deck.cards_left / 2)
  end

  it("should be able to start a round") do
    game = Game.new()
    expect(game.start_round().rank).to eq(8)
  end

  it("should judge who wins the round") do
    game = Game.new()
    card1 = Card.new("J", "Spades")
    card2 = Card.new(7, "Diamonds")
    card3 = Card.new(3, "Hearts")
    expect(game.judge(card1, card2)).to eq(card1)
    expect(game.judge(card3, card2)).to eq(card2)
  end
end
