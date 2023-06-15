# frozen_string_literal: true

# Игрок
class Player
  attr_accessor :money
  attr_reader :name

  def initialize(name, money)
    @name = name
    @money = money
  end

  def get_turn(possible_actions)
    UI.choose('Выбирете действие', possible_actions)
  end
end
