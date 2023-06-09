# frozen_string_literal: true

# Колода карт
class Deck
  ONE =    '🂢🂲🃂🃒🂣🂳🃃🃓🂤🂴🃄🃔🂥🂵🃅🃕🂦🂶🃆🃖🂧🂷🃇🃗🂨🂸🃈🃘🂩🂹🃉🃙🂪🂺🃊🃚'.chars
  # .each_slice(4).to_a
  TEN =    '🂫🂻🃋🃛🂭🂽🃍🃝🂮🂾🃎🃞'.chars
  ELEVEN = '🂡🂱🃁🃑'.chars
  CARD_BACK = '🂠'

  def self.card_back
    CARD_BACK
  end

  def self.score_for_card_with_score(card, curr_score)
    [
      *Deck::ONE.zip(Array.new(Deck::ONE.size, 1)),
      *Deck::TEN.zip(Array.new(Deck::TEN.size, 10)),
      *Deck::ELEVEN.zip(Array.new(Deck::ELEVEN.size, (curr_score + 11) > 21 ? 1 : 11))
    ].to_h[card]
  end

  def initialize
    @cards = [*ONE, *TEN, *ELEVEN].shuffle!(random: Random.new((Time.now.to_f * 1000).to_i))
  end

  def card_get
    @cards.pop
  end
end
