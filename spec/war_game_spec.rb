require("rspec")
require_relative("../lib/war_game")
require_relative("../lib/card_deck")

describe("war_game") do
  it("should split up the deck between both players at the start of the game") do
    game = WarGame.new()
    game.start_game
    expect(game.player1.deck.cards_left).to eq(CardDeck.new.cards_left / 2)
    expect(game.player1.deck.cards_left).to eq(game.player2.deck.cards_left)
  end

  it("should be able to start a non-war round") do
    game = WarGame.new()
    card1 = Card.new("J", "Spades")
    card2 = Card.new(7, "Diamonds")
    game.player1.set_hand([card1])
    game.player2.set_hand([card2])
    game.start_round()
    expect(game.player1.deck.cards_left).to eq(2)
    expect(game.player2.deck.cards_left).to eq(0)
  end

  it("should judge who wins a war round") do
    game = WarGame.new()
    game.player1.set_hand([Card.new("J", "Spades"), Card.new(10, "Spades"), Card.new(9, "Spades"), Card.new(8, "Spades"), Card.new(7, "Spades"), Card.new(6, "Spades")])
    game.player2.set_hand([Card.new("J", "Hearts"), Card.new(10, "Hearts"), Card.new(9, "Hearts"), Card.new(8, "Hearts"), Card.new(6, "Hearts"), Card.new(7, "Hearts")])
    player1_count = game.player1.deck.cards_left
    player2_count = game.player2.deck.cards_left
    game.start_round()
    expect(game.player1.deck.cards_left).to eq(player1_count + 5)
    expect(game.player2.deck.cards_left).to eq(player2_count - 5)
  end
end
