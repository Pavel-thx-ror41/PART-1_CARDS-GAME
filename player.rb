# frozen_string_literal: true

# Игрок
class Player
  attr_accessor :money

  def initialize(name, money)
    @name = name
    @money = money
  end

  def get_turn(player_game_info, possible_actions)
    # TODO
    # binding.pry

    # player_game_info.show
    # puts possible_actions
    #
    # # ask_for_action
    # gets.chop
  end
end
