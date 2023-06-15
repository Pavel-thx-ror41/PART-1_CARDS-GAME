# frozen_string_literal: true

# Игра
class Game
  PLAYER_ACTIONS_ALWAYS = { skip_turn: 'Пропустить ход', open_cards: 'Открыть карты и закончить игру' }.freeze
  PLAYER_ACTIONS_ADDITIONAL = { deal_card: 'Добрать карту' }.freeze
  PLAYER_ACTIONS_ALL_POSSIBLE = PLAYER_ACTIONS_ALWAYS.merge(PLAYER_ACTIONS_ADDITIONAL).freeze
  DEALER_ACTIONS_SKIP = { skip_turn: 'Пропустить ход' }.freeze
  DEALER_ACTIONS_CARD = { deal_card: 'Добрать карту' }.freeze

  def self.score_for_card_with_score(card, curr_score)
    [
      *Deck::DIGITS.each_slice(4).to_a.each_with_index.map do |digit, index|
        digit.map { |digits_card| [digits_card, index + 2] }
      end.flatten(1),
      *Deck::FIGURES.zip(Array.new(Deck::FIGURES.size, 10)),
      *Deck::ACES.zip(Array.new(Deck::ACES.size, (curr_score + 11) > 21 ? 1 : 11))
    ].to_h[card]
  end

  def self.score_for_cards(cards)
    cards.reduce(0) { |score, card| score + Game.score_for_card_with_score(card, score) }
  end

  def self.possible_dealer_actions(dealer_cards)
    # - Добавить карту (если очков менее 17). У дилера появляется новая карта (для пользователя закрыта).
    #   Может быть добавлена только одна карта.
    # - Пропустить ход (если очков у дилера 17 или более). Ход переходит игроку.
    Game.score_for_cards(dealer_cards) < 17 && dealer_cards.count < 3 ? DEALER_ACTIONS_CARD : DEALER_ACTIONS_SKIP
  end

  def self.possible_player_actions(player_cards_count)
    # skip_turn # Пропустить
    # open_cards # Открыть карты, закончить игру, подсчитав очки
    #   player_force_game_end_by_opening
    # deal_card CAN_if player_cards.count < 3 # Добавить карту, если у игрока карт меньше 3-х
    #   deal_card(player, game_deck)
    player_cards_count > 2 ? PLAYER_ACTIONS_ALWAYS : PLAYER_ACTIONS_ALL_POSSIBLE
  end

  def initialize(dealer, player)
    # player
    @player = player
    @player_cards = []

    # dealer
    @dealer = dealer
    @dealer_cards = []

    # casino
    @deck = Deck.new
    @open_cards_flag = false
    2.times do
      @player_cards << @deck.card_get
      @dealer_cards << @deck.card_get
    end
  end

  def play
    loop do
      show_game
      play_turn("player_#{player_turn}")
      break if game_end?

      show_game
      play_turn("dealer_#{dealer_turn}")
      break if game_end?
    end
    winner
  end

  private

  def play_turn(turn)
    case turn
    when 'player_skip_turn'
      # do nothing
    when 'player_open_cards'
      @open_cards_flag = true
    when 'player_deal_card'
      @player_cards << @deck.card_get
    when 'dealer_skip_turn'
      # do nothing
    when 'dealer_deal_card'
      @dealer_cards << @deck.card_get
    else
      raise 'Ошибка в программе, запрошен неизвестный ход.'
    end
  end

  def game_end?
    puts 'У игроков по 3 карты, конец игры.' if @dealer_cards.count > 2 && @player_cards.count > 2
    @open_cards_flag || (@dealer_cards.count > 2 && @player_cards.count > 2)
  end

  def winner
    dealer_score = (Game.score_for_cards(@dealer_cards) - 21).abs
    player_score = (Game.score_for_cards(@player_cards) - 21).abs

    puts 'Игра окончена.     ' \
         "карты игрока:#{show_cards(@player_cards)} , очков: #{Game.score_for_cards(@player_cards)}     " \
         "карты крупье:#{show_cards(@dealer_cards)} , очков: #{Game.score_for_cards(@dealer_cards)}" \

    if dealer_score == player_score then nil
    elsif dealer_score < player_score then @dealer
    elsif dealer_score > player_score then @player
    end
  end

  def dealer_turn
    filtered_dealer_choice = nil
    until filtered_dealer_choice
      action = @dealer.get_turn(Game.possible_dealer_actions(@dealer_cards))
      filtered_dealer_choice = action if Game.possible_dealer_actions(@dealer_cards).keys.include?(action)
    end
    filtered_dealer_choice
  end

  def player_turn
    filtered_player_choice = nil
    until filtered_player_choice
      ui_input = @player.get_turn(Game.possible_player_actions(@player_cards.count))
      filtered_player_choice = ui_input if Game.possible_player_actions(@player_cards.count).keys.include?(ui_input)
    end
    filtered_player_choice
  end

  def show_game
    puts
    puts "Текущая игра:  ваши карты: #{show_cards(@player_cards)}" \
         " , #{Game.score_for_cards(@player_cards)} очков" \
         "   карты крупье: #{show_back(@dealer_cards)}"
  end

  def show_cards(cards)
    cards.map(&' '.method(:+)).join
  end

  def show_back(cards)
    (Deck.card_back * cards.count).chars.map(&' '.method(:+)).join
  end
end
