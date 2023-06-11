# frozen_string_literal: true

# Колода карт
class Deck
  DIGITS = '🂢🂲🃂🃒🂣🂳🃃🃓🂤🂴🃄🃔🂥🂵🃅🃕🂦🂶🃆🃖🂧🂷🃇🃗🂨🂸🃈🃘🂩🂹🃉🃙🂪🂺🃊🃚'.chars
  FIGURES = '🂫🂻🃋🃛🂭🂽🃍🃝🂮🂾🃎🃞'.chars
  ACES = '🂡🂱🃁🃑'.chars
  CARD_BACK = '🂠'

  def self.card_back
    CARD_BACK
  end

  def initialize
    @cards = [*DIGITS, *FIGURES, *ACES].shuffle!(random: Random.new((Time.now.to_f * 1000).to_i))
  end

  def card_get
    @cards.pop
  end
end
