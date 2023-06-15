#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

require_relative 'deck'
require_relative 'dealer'
require_relative 'player'
require_relative 'game'

# UI
class UI
  def self.ask(prompt)
    print "#{prompt}: "
    gets.chomp
  end
end

# Основной класс, приложение
class App
  BET = 10
  INITIAL_PLAYERS_MONEY = 100

  def run
    test

    dealer = Dealer.new(INITIAL_PLAYERS_MONEY)
    player = Player.new(UI.ask('Введите Ваше имя'), INITIAL_PLAYERS_MONEY)

    loop do
      dealer.money -= BET
      player.money -= BET
      game_bank = BET * 2
      case Game.new(dealer, player).play
      when nil
        dealer.money += game_bank / 2
        player.money += game_bank / 2
        puts "Ничья. Крупье:#{dealer.money}$, #{player.name}:#{player.money}$"
      when dealer
        dealer.money += game_bank
        puts "Выиграл крупье. Крупье:#{dealer.money}$, #{player.name}:#{player.money}$"
      when player
        player.money += game_bank
        puts "Выиграл игрок: #{player.name}. Крупье:#{dealer.money}$, #{player.name}:#{player.money}$"
      else
        raise 'Ошибка программы, от Game.play, ожидается результат игры: nil, player или dealer'
      end
      puts
      exit if player.money < BET || dealer.money < BET || !UI.ask('Играем ещё? (Y/N)').to_s.upcase.eql?('Y')
    end
  end

  private

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
