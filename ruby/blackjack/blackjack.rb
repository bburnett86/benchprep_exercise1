class Card
  attr_accessor :suit, :name, :value

  def initialize(suit, name, value)
    @suit, @name, @value = suit, name, value
  end
end

class Deck
  attr_accessor :playable_cards
  SUITS = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => [11, 1]}

  def initialize
    shuffle
  end

  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = []
    SUITS.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end
end

class Hand
  attr_accessor :cards, :total

  def initialize
    @cards = []
  end

  def total
    return 0 if !self.cards
    values_arr = @cards.map{|x| x.value}
    values_arr.inject{ |sum, x| sum + x}
  end

  def ace_hypothetical(card)
    if card.value.is_a?(Array) && self.total <= 10
      card.value = card.value[0]
    elsif card.value.is_a?(Array) && self.total >= 10 
      card.value = card.value[1]
    elsif card.value.is_a?(Array)
      card.value = card.value[1]
    end
  end
end

class Runner
  def start
    deck = Deck.new
    player = Hand.new
    dealer = Hand.new
    card = deck.deal_card
    player.ace_hypothetical(card)
    player.cards << card
    card2 = deck.deal_card
    player.ace_hypothetical(card2)
    player.cards << card2
    card = deck.deal_card
    dealer.ace_hypothetical(card)
    dealer.cards << card
    card2 = deck.deal_card
    dealer.ace_hypothetical(card2)
    dealer.cards << card2
    puts "The first cards you were dealt were a #{card.name} of #{card.suit} and a #{card2.name} of #{card2.suit} their combined value is #{player.total}."
    another = ''
    if player.total.to_i != 21 
      puts "Would you like to draw another card?"
      puts "Answer (y or n)"
      another = gets.strip
    else
      puts "The most recent card you were dealt was a #{card.name} of #{card.suit}"
      puts "Your card value is exactly 21! You Win!"
      return
    end
    until another != "y"
      card = deck.deal_card
      player.ace_hypothetical(card)
      player.cards << card
      if player.total.to_i == 21
        puts "The most recent card you were dealt was a #{card.name} of #{card.suit}"
        puts "Your card value is exactly 21! You Win!"
        return
      elsif player.total.to_i > 21
        puts "The most recent card you were dealt was a #{card.name} of #{card.suit}"
        puts "Your card value is #{player.total} has gone over 21, I'm sorry, you've lost."
        return
      else
        puts "The most recent card you were dealt was a #{card.name} of #{card.suit} combined with your previous value, your total is #{player.total}."
        puts "Would you like to draw another card?"
        puts "Answer (y or n)"
        another = gets.strip
      end
    end
    result = ""
    until result == "win" || result == "loss"
      if dealer.total < 17 && dealer.total < player.total
        card = deck.deal_card
        dealer.ace_hypothetical(card)
        dealer.cards << card
        result = "again"
      elsif dealer.total > 21
        puts "You win! The Dealer dealt themself:"
        dealer.cards.each do |card|
          puts "a #{card.name} of #{card.suit}"
        end
        puts "Which put their value at a #{dealer.total}, over 21"
        return result = "win"
      elsif dealer.total >= 17 && dealer.total < player.total
        puts "You win! The Dealer dealt themself:"
        dealer.cards.each do |card|
          puts "a #{card.name} of #{card.suit}"
        end
        puts "Which put their value at a #{dealer.total}"
        puts "Rules say that the dealer can't draw anymore cards over a value of 17"
        puts "Your total value was #{player.total}"
        return result = "win"
      elsif dealer.total >= 17 && dealer.total >= player.total
        puts "You lose. The Dealer dealt themself:"
        dealer.cards.each do |card|
          puts "a #{card.name} of #{card.suit}"
        end
        puts "Which put their value at a #{dealer.total}, equal to or greater than your value of #{player.total}"
        puts "The House wins."
        return result = "loss"
      else
        puts "You lose. The Dealer dealt themself:"
        dealer.cards.each do |card|
          puts "a #{card.name} of #{card.suit}"
        end
        puts "Which put their value at a #{dealer.total}, equal to or greater than your value of #{player.total}"
        puts "The House wins."
        return result = "loss"
      end
    end
  end
end

r = Runner.new
r.start

require 'test/unit'

class CardTest < Test::Unit::TestCase
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end
  
  def test_card_suit_is_correct
    assert_equal @card.suit, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end
  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
  end
  
  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end
  
  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    assert(!@deck.playable_cards.include?(card))
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
end