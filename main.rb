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
    result_choice = nil
    until result_choice
      print "#{prompt}, доступно: " \
          "#{choices.values.each_with_index.map { |value, index| "#{index + 1}) #{value}" }.join(', ')}. Ваш выбор: "
      user_input_digit = gets.chomp.to_i
      result_choice = choices.keys[user_input_digit - 1] if user_input_digit.positive?
    end
    result_choice
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
        puts
        puts 'Ничья.'
      when dealer
        dealer.money += game_bank
        puts
        puts 'Выиграл крупье.'
      when player
        player.money += game_bank
        puts
        puts "Выиграл игрок: #{player.name}."
      else
        raise 'Ошибка программы, от Game.play, ожидается результат игры: nil, player или dealer'
      end
      show_money(dealer, player)
      puts
      exit if player.money < BET || dealer.money < BET || !UI.ask('Играем ещё? (Y/N)').to_s.upcase.eql?('Y')
    end
  end

  def show_money(dealer, player)
    puts "Крупье:#{dealer.money}$, Игрок:#{player.money}$"
  end
end

App.new.run
