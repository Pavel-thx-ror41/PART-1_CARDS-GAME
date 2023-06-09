#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

require_relative 'deck'
require_relative 'dealer'
require_relative 'player'
require_relative 'game'

# Основной класс, приложение
class App
  def initialize; end

  def run
    deck = Deck.new
    1..52.times do
      print "#{deck.card_get} "
    end
    puts

    raise unless Deck.score_for_card_with_score('🃑', 10) == 11
    raise unless Deck.score_for_card_with_score('🃑', 11) == 1

    binding.pry
  end
end

App.new.run
