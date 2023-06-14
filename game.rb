# frozen_string_literal: true

# Игра
class Game
  def self.score_for_card_with_score(card, curr_score)
    [
      *Deck::DIGITS.each_slice(4).to_a.each_with_index.map do |digit, index|
        digit.map { |card| [card, index + 2] }
      end.flatten(1),
      *Deck::FIGURES.zip(Array.new(Deck::FIGURES.size, 10)),
      *Deck::ACES.zip(Array.new(Deck::ACES.size, (curr_score + 11) > 21 ? 1 : 11))
    ].to_h[card]
  end

  def initialize(dealer, player)
    # player
    @player = player
    @player.money -= 10
    @player_cards = []

    # dealer
    @dealer = dealer
    @dealer.money -= 10
    @dealer_cards = []

    # casino
    @deck = Deck.new
    @game_bank = 20
    2.times do
      @player_cards << @deck.card_get
      @dealer_cards << @deck.card_get
    end
  end

  def play
    loop do
      show_game
      turn_player
      turn_dealer
      # exit loop if game end
    end
    "Победил ..."
  end

  private

  def turn_dealer
    _dealer_turn = get_correct_dealer_turn(
      dealer_game_info,
      @dealer.do_turn(dealer_game_info, possible_diler_actions(dealer_game_info))
    )
    binding.pry
    # player.do_turn(game_info) # 1 of 2, by dealer:
    # 1 skip CAN_if dealer_cards.scores > 16
    # # do nothing
    # 2 more_card CAN_if dealer_cards.scores < 17 && dealer_cards.count < 3
    # deal_card(dealer, game_deck)
  end

  def get_correct_dealer_turn(dealer_game_info, turn)
    turn = nil
    until turn
      turn = dealer_can_turn?(turn)
    end
  end

  def dealer_can_turn?(turn)
    # TODO
    # possible_dealer_actions(_player_game_info)
  end

  def possible_dealer_actions(_player_game_info)
    # TODO
  end

  def turn_player
    _player_turn = get_correct_player_turn(
      player_game_info,
      @player.do_turn(player_game_info, possible_player_actions(player_game_info))
    )
    binding.pry
    # do_turn(game_info) # 1 of 3, by user:
    # 3 skip # Пропустить
    #   # do nothing
    # 4 more_card CAN_if player_cards.count < 3 # Добавить карту
    #   deal_card(player, game_deck)
    # 5 open_cards # Открыть карты, закончить игру
    #   player_force_game_end_by_opening
  end

  def get_correct_player_turn(player_game_info, turn)
    turn = nil
    until turn
      turn = player_can_turn?(player_game_info, turn)
    end
  end

  def player_can_turn?(_player_game_info, _turn)
    # TODO
    # possible_player_actions(_player_game_info)
  end

  def possible_player_actions(_player_game_info)
    # TODO
  end

  def show_game
    # TODO
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
