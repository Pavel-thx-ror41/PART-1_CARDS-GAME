#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

require_relative 'deck'
require_relative 'dealer'
require_relative 'player'
require_relative 'game'

# Основной класс, приложение
class App
  def run
    test
    dealer = Dealer.new(100)
    player = Player.new(ask('Введите Ваше имя'), 100)

    # binding.pry
    loop do
      puts Game.new(dealer, player).play
      exit if player.money < 10 || dealer.money < 10 || ask('Ещё игру?').to_s.upcase.eql?('N')
    end
  end

  private

  def ask(prompt)
    print "#{prompt}: "
    gets.chomp
  end

  def test
    test_deck
    test_game
  end

  def test_deck
    deck = Deck.new
    1..52.times { deck.card_get }

    begin
      wrong_card = deck.card_get
    rescue StandardError
      # do nothing
    end
    raise 'Проверка Колоды. В колоде должно быть 52 карты' if wrong_card
  end

  def test_game

    # Подсчёт очков
    # Цифры
    raise 'Проверка Игры. Проверка посчёта очков для 🂧.' unless
      Game.score_for_card_with_score('🂧', 10) == 7

    raise 'Проверка Игры. Проверка посчёта очков для 🃃.' unless
      Game.score_for_card_with_score('🃃', 21) == 3

    # Туз
    raise 'Проверка Игры. Проверка посчёта очков для 🃑.' unless
      Game.score_for_card_with_score('🃑', 10) == 11

    raise 'Проверка Игры. Проверка посчёта очков для 🂱.' unless
      Game.score_for_card_with_score('🂱', 11) == 1
  end
end

App.new.run
