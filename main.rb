#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

require_relative 'deck'
require_relative 'dealer'
require_relative 'player'
require_relative 'game'
require_relative 'tests'

# UI
class UI
  def self.ask(prompt)
    print "#{prompt}: "
    gets.chomp
  end

  def self.choose(prompt, choices)
    player_choice = nil
    until player_choice
      print "#{prompt}, доступно: " \
          "#{choices.values.each_with_index.map { |value, index| "#{index + 1}) #{value}" }.join(', ')}. Ваш выбор:"
      player_choice = choices.keys[gets.chomp.to_i - 1]
    end
    player_choice
  end
end

# Основной класс, приложение
class App
  BET = 10
  INITIAL_PLAYERS_MONEY = 100

  def run
    Tests.new.test

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
end

App.new.run
