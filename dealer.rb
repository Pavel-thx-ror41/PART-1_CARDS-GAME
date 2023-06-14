# frozen_string_literal: true

# Крупье
class Dealer
  attr_accessor :money

  def initialize(money)
    @money = money
  end

  def get_turn(_dealer_game_info, _possible_actions)
    # TODO
    # binding.pry

    # dealer_game_info.show
    # puts possible_actions
    #
    # possible_actions[random]
  end
end
