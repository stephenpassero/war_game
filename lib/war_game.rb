require("pry")
require_relative("card_deck")
require_relative("player")

class WarGame
  attr_reader :player1, :player2

  def initialize()
    @cardValues = {1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9, 10 => 10, "J" => 11, "Q" => 12, "K" => 13, "A" => 14}
    @deck = CardDeck.new()
    @player1 = Player.new()
    @player2 = Player.new()
  end

  def distribute_deck(first_player, second_player, deck_to_distribute)
    deck_to_distribute.shuffle!
    two_decks = deck_to_distribute.split_in_two()
    first_player.deck = CardDeck.new(two_decks[0])
    second_player.deck = CardDeck.new(two_decks[1])
  end

  def start_game()
    distribute_deck(@player1, @player2, @deck)
    return "Player 1 and Player 2 both have 26 cards left"
  end

  def start_round()
    return judge(@player1.play_top_card(), @player2.play_top_card())
  end

  def winner()
    if @player1.deck.cards_left == 0
      return "Player 1";
    elsif @player2.deck.cards_left == 0
      return "Player 2"
    end
  end

  def player_cards_left(player)
    player.cards_left
  end
end

  private
  def value(card)
    @cardValues.fetch(card.rank)
  end

  def judge(card1, card2)
    cards = [card1, card2].shuffle
    if value(card1) > value(card2)
      @player1.deck.add(cards)
      return "Player 1 took a #{card2.rank} of #{card2.suit} with a #{card1.rank} of #{card1.suit}"
    elsif value(card2) > value(card1)
      @player2.deck.add(cards)
      return "Player 2 took a #{card1.rank} of #{card1.suit} with a #{card2.rank} of #{card2.suit}"
    else # values are equal
      handle_war(cards)
    end
  end

  def handle_war(card_collection)
    if @player1.deck.cards_left >= 4 && @player2.deck.cards_left >= 4
      3.times {card_collection.push(@player1.play_top_card(), @player2.play_top_card())}
      new_card1 = @player1.play_top_card()
      new_card2 = @player2.play_top_card()
      card_collection.push(new_card1, new_card2)
      new_card1_value = value(new_card1)
      new_card2_value = value(new_card2)
      if value(new_card1) > value(new_card2)
        @player1.deck.add(card_collection)
        return "War! Player 1 took a #{new_card2.rank} of #{new_card2.suit} with a #{new_card1.rank} of #{new_card1.suit}"
      elsif value(new_card2) > value(new_card1)
        @player2.deck.add(card_collection)
        return "War! Player 2 took a #{new_card1.rank} of #{new_card1.suit} with a #{new_card2.rank} of #{new_card2.suit}"
      else # value(new_card2) == value(new_card1)
        handle_war(card_collection)
      end
    elsif @player1.deck.cards_left >= 4 && @player2.deck.cards_left < 4
      return "Player 1"
    elsif @player1.deck.cards_left < 4 && @player2.deck.cards_left > 4
      return "Player 2"
    end
  end
