require("rspec")
require("game")
require("card_deck")

describe("#game") do
  it("should split up the deck between both players at the start of the game") do
    game = Game.new()
    game.start_game
    expect(game.player1.deck.cards_left).to eq(CardDeck.new.cards_left / 2)
    expect(game.player1.deck.cards_left).to eq(game.player2.deck.cards_left)
  end

  it("should be able to start a round") do
    game = Game.new()
    card1 = Card.new("J", "Spades")
    card2 = Card.new(7, "Diamonds")
    game.player1.set_hand([card1])
    game.player2.set_hand([card2])
    game.start_round()
    expect(game.player1.deck.cards_left).to eq(2)
    expect(game.player2.deck.cards_left).to eq(0)
  end

  # it("should judge who wins the round") do
  #   game = Game.new()
  #   card1 = Card.new("J", "Spades")
  #   card2 = Card.new(7, "Diamonds")
  #   card3 = Card.new(3, "Hearts")
  #   expect(game.judge(card1, card2)).to eq(card1)
  #   expect(game.judge(card3, card2)).to eq(card2)
  # end
end
