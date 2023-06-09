Игра Black Jack

    # ПСЕВДОКОД

    # app

    # deck
        # 2..10(36), J..K(12), A(4)
        # 52 карты

    # dealer
        @name = 'крупье'
        @money = 100
        do_turn(game_info) # 1 of 2, by dealer:
          1 skip CAN_if dealer_cards.scores > 16
              # do nothing
          2 more_card CAN_if dealer_cards.scores < 17 && dealer_cards.count < 3
              deal_card(dealer, game_deck)

    # player
        @name = input
        @money = 100
        do_turn(game_info) # 1 of 3, by user:
            3 skip # Пропустить
                # do nothing
            4 more_card CAN_if player_cards.count < 3 # Добавить карту
                deal_card(player, game_deck)
            5 open_cards # Открыть карты, закончить игру
                player_force_game_end_by_opening
    
    # game
        new(dealer, player)
            game_deck.new(deck)
            game_bank = 20
            dealer.money -= 10
            player.money -= 10
            [dealer, player].each # deal 2 cards for each
                .deal_card(game_deck)
                .deal_card(game_deck)

        game_loop
            show_game_info
            game_do_turn( player.do_turn( game_info_for_player ))
            show_game_info
            game_do_turn( dealer.do_turn( game_info_for_dealer ))

        game_do_turn()
          check_game_end

        check_game_end
          game_scores = [scores(player_cards), scores(dealer_cards)]
          end_game return_winner, do_checkout  DO_IT_if game_end_by_scores? || FORCE_GAME_END_FLAG || (dealer_cards.count > 2 && player_cards.count > 2)

        return_winner(player_cards, dealer_cards)
          ps = (player_cards-21).abs
          ds = (dealer_cards-21).abs
          if    ps==ds 0
          elsif ps<ds  1
          else  ds<ps  2
          # [[1,2], [4,5]].transpose.map(&:sum) #=> [5,7]
          # banks = [50,70]
          # bame_result = []

        do_checkout
          ...

        show_game_info
            show_cards_back(dealer.cards)
            show_cards(player.cards)
            player.score = calc_new_score(player.score, player.cards)
            show_scores(player.score)

        calc_new_score(player_curr_score, cards)
            cards.each
        #       score_for_card_with_score(card, player_curr_score)
        #     2..10 :: +1
        #     J,Q,K :: +10
        #     A     :: (player_curr_score+11) < 21 ? +11 : +1
    

* Есть игрок (пользователь) и дилер (управляется программой).
* Вначале, запрашиваем у пользователя имя после чего, начинается игра.
* При начале игры у пользователя и дилера в банке находится 100 долларов
* Пользователю выдаются случайные 2 карты, которые он видит (карты указываем условными обозначениями, например, «К+» - король крестей, «К<3» - король черв, «К^» - король пик, «К<>» - король бубен и т.д. При желании, можете использовать символы юникода для мастей.)
* Также 2 случайные карты выдаются «дилеру», против которого играет пользователь. Пользователь не видит карты дилера, вместо них показываются звездочки.
* Пользователь видит сумму своих очков. Сумма считается так: от 2 до 10 - по номиналу карты, все «картинки» - по 10, туз - 1 или 11, в зависимости от того, какое значение будет ближе к 21 и что не ведет к проигрышу (сумме более 21).
* После раздачи, автоматически делается ставка в банк игры в размере 10 долларов от игрока и диллера. (У игрока и дилера вычитается 10 из банка)
* После этого ход переходит пользователю. У пользователя есть на выбор 3 варианта:
  - Пропустить. В этом случае, ход переходит к дилеру (см. ниже)
  - Добавить карту. (только если у пользователя на руках 2 карты). В этом случае игроку добавляется еще одна случайная карта, сумма очков пересчитывается, ход переходит дилеру. Может быть добавлена только одна карта. 
  - Открыть карты. Открываются карты дилера и игрока, игрок видит сумму очков дилера, идет подсчет результатов игры (см. ниже).
* Ход дилера (управляется программой, цель - выиграть, т.е набрать сумму очком, максимально близкую к 21). Дилер может:
  - Пропустить ход (если очков у дилера 17 или более). Ход переходит игроку. 
  - Добавить карту (если очков менее 17). У дилера появляется новая карта (для пользователя закрыта). После этого ход переходит игроку. Может быть добавлена только одна карта.
* Игроки вскрывают карты либо по достижению у них по 3 карты (автоматически), либо когда пользователь выберет вариант «Открыть карты». После этого пользователь видит карты дилера и сумму его очков, а также результат игры (кто выиграл и кто проиграл).
* Подсчет результатов:
  - Выигрывает игрок, у которого сумма очков ближе к 21
  - Если у игрока сумма очков больше 21, то он проиграл
  - Если сумма очков у игрока и дилера одинаковая, то объявляется ничья и деньги из банка возвращаются игрокам
  - Сумма из банка игры переходит к выигравшему
* После окончания игры, спрашиваем у пользователя, хочет ли он сыграть еще раз. Если да, то игра начинается заново с раздачи карт, если нет - то завершаем работу.




