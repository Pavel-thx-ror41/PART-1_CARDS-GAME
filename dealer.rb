# frozen_string_literal: true

# Крупье
class Dealer
  attr_accessor :money

  def initialize(money)
    @money = money
  end

  def get_turn(possible_actions)
    puts "Крупье произвёл действие: #{possible_actions.values.first}"
    possible_actions.keys.first
  end
end
