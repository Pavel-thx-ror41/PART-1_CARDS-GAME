# frozen_string_literal: true

# Игра
class Game
  PLAYER_ACTIONS_ALWAYS = { skip_turn: 'Пропустить ход', open_cards: 'Открыть карты и закончить игру' }.freeze
  PLAYER_ACTIONS_ADDITIONAL = { deal_card: 'Добрать карту' }.freeze
  PLAYER_ACTIONS_ALL_POSSIBLE = PLAYER_ACTIONS_ALWAYS.merge(PLAYER_ACTIONS_ADDITIONAL).freeze

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
      # play_turn("dealer_#{dealer_turn}")
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
    else
      raise 'Ошибка в программе, запрошен неизвестный ход.'
    end
  end

  def game_end?
    @open_cards_flag || (@dealer_cards.count > 2 && @player_cards.count > 2)
  end

  def winner
    dealer_score = (Game.score_for_cards(@dealer_cards) - 21).abs
    player_score = (Game.score_for_cards(@player_cards) - 21).abs

    if dealer_score == player_score then nil
    elsif dealer_score < player_score then @dealer
    elsif dealer_score > player_score then @player
    end
  end

  def dealer_game_info
    [@dealer_cards, @player_cards.count]
  end

  def dealer_turn
    _dealer_turn = get_correct_dealer_turn(
      dealer_game_info,
      @dealer.get_turn(dealer_game_info, possible_dealer_actions(dealer_game_info))
    )
    # binding.pry
    # TODO
    # - Пропустить ход (если очков у дилера 17 или более). Ход переходит игроку.
    # 1 skip CAN_if dealer_cards.scores > 16
    #   # do nothing
    # - Добавить карту (если очков менее 17). У дилера появляется новая карта (для пользователя закрыта)
    # 2 more_card CAN_if dealer_cards.scores < 17 && dealer_cards.count < 3
    #   deal_card(dealer, game_deck)
  end

  def player_turn
    player_choice = nil
    until player_choice
      ui_choice = @player.get_turn(Game.possible_player_actions(@player_cards.count))
      player_choice = ui_choice if Game.possible_player_actions(@player_cards.count).keys.include?(ui_choice)
      player_choice
    end
    player_choice
  end

  def show_game
    puts
    puts "Игрок: #{@player.name} $#{@player.money}.   " \
         "Текущая игра:  ваши карты: #{@player_cards.map(&' '.method(:+)).join}" \
         " , #{Game.score_for_cards(@player_cards)} очков" \
         "   карты крупье [DEBUG]: #{@dealer_cards.map(&' '.method(:+)).join}" \
         " , #{Game.score_for_cards(@dealer_cards)} очков "
    #    "   карты крупье: #{(Deck.card_back * @dealer_cards.count).chars.map(&' '.method(:+)).join}"
  end

  # PlayerGameInfo = Struct.new(:user_cards, :user_scores, :dealer_cards) do
  #   def show_player
  #     puts "#{user_cards} #{user_scores}"
  #   end
  #
  #   def show_dealer
  #     puts dealer_cards.to_s
  #   end
  # end
  #
  # def player_game_info
  #   Player_Game_Info.new('A7J', 12, 'XX')
  # end
end
