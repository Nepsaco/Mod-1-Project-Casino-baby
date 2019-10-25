require_relative './config/environment'
require 'pry'


class Cli 

    @@current_user = nil 
    @@deck_id = nil 
    @@dealer_hand = []
    @@user_hand = []
    @@bet = 0 
    @@dealer_img = []
    @@user_img= []

    def welcome
        system("clear")
        puts "Welcome!".green
        puts "Blackjack".yellow
    end

    def main_menu
      puts 'Pick an option'.red
      puts '1. login'.green
      puts '2. sign up'.green
      puts '3. leaderboard'.green
      puts '4. exit'.green
        user_input = gets.strip
        case user_input.to_i 
            when 1
            login    
            when 2
                system("clear")
            sign_up    
            when 3
            leaderboard    
            when 4
                exit 
            else 
                system("clear")
                puts "Invalid input, try again".red 
                main_menu
        end
    end


    def exit 
        @@current_user.update(balance: @@current_user[0].balance)
    end 

    def login 
        system("clear")
        puts "Type in Username".green
        username = gets.chomp 
        if User.where(user_name: username.capitalize) == []
          puts "sorry you don't exist! would you like to sign up? y/n".green
            i = 1
            while i < 5
                username1 = gets.chomp
                if username1 == "y"
                    system("clear")
                    sign_up
                    break
                elsif username1.downcase == "n"
                    system("clear") 
                    main_menu
                    break
                else
                  puts "Invalid input try again".red 
                end 
                i += 1
            end
            system("clear")
            main_menu
        else
          @@current_user = User.where(user_name: username.capitalize).limit(1)
	      summary_page
        end
      end 


    def sign_up 
      puts "Type in your first name.".green
        @@current_user = []
        username = gets.chomp 
        if  User.where(user_name: username.capitalize)==[] 
	    @@current_user << User.create(user_name: username.capitalize, balance: 1000)
            summary_page
        else 
          puts "Username already exists, try again.".green 
            sign_up 
        end 
    end 
    
    def summary_page
        system("clear")
        puts "Username: #{@@current_user[0].user_name.capitalize}, Balance: $#{@@current_user[0].balance}"
        puts ""
        puts "To start game type y/n".green
        i = 1
        while i < 5
            username1 = gets.chomp
            if username1.downcase == "y" 
                system("clear")
                start_game               
                break
            elsif username1.downcase == "n"
                main_menu
                break
            else
              puts "Invalid input try again".red 
            end 
            i += 1
        end 
        system("clear")
        main_menu
        
    end

    def leaderboard 
        if @@current_user != []
          @@current_user.update(balance: @@current_user[0].balance)
        end
        system("clear")
        i = 1
        money_leaderboard = User.order(balance: :desc)
        money_leaderboard.each do |user| 
            puts "#{i}. Username: #{user.user_name} Balance: $#{user.balance}"
            i += 1
        end
        puts ""
        puts ""
        puts "back to main menu y/n".green 
        i = 1
        while i < 5
            username1 = gets.chomp
            if username1.downcase == "y" 
                system("clear")
                main_menu
                break
            elsif username1.downcase == "n"
                leaderboard
                break
            else
              puts "Invalid input try again".red 
            end 
            i += 1
        end 
        system("clear")
        main_menu
    end 

    def start_game
        clear_cards
        set_bet
        system("clear")
        shuffle_deck
        initial_deal_user
        initial_deal_dealer
        display_dealer_hand
        puts ""
        display_user_hand
        user_turn

    end
   
    def shuffle_deck
        shuffle = RestClient.get('https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6')
        shuffle_j = JSON.parse(shuffle) 
        @@deck_id = shuffle_j["deck_id"]
    end
    
    def deal_card
        draw_a_card = RestClient.get("https://deckofcardsapi.com/api/deck/#{@@deck_id}/draw/?count=1")
        draw_cards_j = JSON.parse(draw_a_card)
    end 

    def initial_deal_user
        card = deal_card 
        @@user_hand << card["cards"][0]["code"] 
        @@user_img << card["cards"][0]["image"]
        card = deal_card
        @@user_hand << card["cards"][0]["code"] 
        @@user_img << card["cards"][0]["image"]
    end 

    def initial_deal_dealer
        card = deal_card
        @@dealer_hand << card["cards"][0]["code"] 
        @@dealer_img << card["cards"][0]["image"]
        card = deal_card
        @@dealer_hand << card["cards"][0]["code"] 
        @@dealer_img << card["cards"][0]["image"]

    end

    def numeric?(lookAhead)
        lookAhead =~ /[[:digit:]]/ 
    end

    def score_in_hand(hand) 
        hand.reduce(0) do |sum, card|
            first_character = card.split('').first
            if numeric?(first_character)
              if first_character == "0"
                sum += 10
              else
                sum += first_character.to_i
              end
            else
                face_cards = {"J" => 10, "Q" => 10, "K" => 10, "A" => 11}
                sum += face_cards[first_character.to_s]
            end
        end
    end


    def display_user_hand
        puts "Your Hand:"
        i = 0
        while i < @@user_hand.length
        system("imgcat #{@@user_img[i]}")
            i+= 1
        end
        card_total = score_in_hand(@@user_hand)
        puts "Your Total is: #{card_total}"
        puts "Your Bet is: #{@@bet}"
    end

    def display_dealer_hand
        puts "Dealer Hand:"
        i = 1
        while i < @@dealer_hand.length
            system("imgcat #{@@dealer_img[i]}")
            i +=1
        end
        card_total = dealer_score_showing
        puts "Dealer Total is: #{card_total}"
    end 

    def display_final_dealer_hand
        puts "DealerHand:"
        i = 0
        while i < @@dealer_hand.length
            system("imgcat #{@@dealer_img[i]}")
            i+= 1
        end
        card_total = score_in_hand(@@dealer_hand)
        puts "Dealer Stays at: #{card_total}"
    end

    def dealer_score_showing
      hand = @@dealer_hand.drop(1)
      hand.reduce(0) do |sum, card|
            first_character = card.split('').first
            if numeric?(first_character)
              if first_character == "0"
                sum += 10
              else
                sum += first_character.to_i
              end
            else
                face_cards = {"J" => 10, "Q" => 10, "K" => 10, "A" => 11}
                sum += face_cards[first_character.to_s]
            end
        end
    end
    
    def set_bet
      if @@current_user[0].balance <= 0 
        broke
      end
      puts "Enter bet amount! You have #{@@current_user[0].balance} to spend."
      user_input = gets.chomp
      if user_input.to_i > 0 && user_input.to_i <= @@current_user[0].balance 
        @@current_user[0].balance.to_i - user_input.to_i
        @@bet = user_input.to_i
      else
        puts "Invalid input try again".red 
        set_bet
      end
    end

    def hit(hand)
        new_card = deal_card["cards"][0]
        new_hand = hand << new_card["code"]
        if hand == @@user_hand
          @@user_img << new_card["image"]
        elsif hand == @@dealer_hand
          @@dealer_img << new_card["image"]
        end
    end


    def broke
        if @@current_user[0].balance <= 0
            system("clear")
            puts "Sorry you're out of money!".red

            puts "beg for more money? y/n".red 
            i = 1
            while i < 5
                no_money = gets.chomp
                if no_money.downcase == "y" 
                    system("clear")
                    @@current_user[0].balance += 1000
                    summary_page
                    break
                elsif no_money.downcase == "n"
                    system("clear")
                    main_menu
                    break
                else
                  puts "Invalid input try again".red 
                end 
                i += 1
            end 
        end 
    end



        def bust 
          # binding.pry
         # if @@user_hand.include?('AH'||'AD'||'AC'||'AS')
          #  @@user_hand << "CC"
          #  binding.pry
          #  score_in_hand(@@user_hand)
          #  user_turn
         # end
         system("clear")
         puts "you busted, you lost #{@@bet}".red
         display_user_hand
         new_balance = @@current_user[0].balance - @@bet 
         @@current_user[0].balance = new_balance 
         puts "Your current total is: $#{new_balance}".green
         puts "start a new game? y/n".green
         i = 1
         while i < 5
             user_input = gets.chomp
             if user_input.downcase == "y" 
                 system("clear")
                 start_game 
                 break
             elsif user_input.downcase == "n"
                 system("clear")
                 main_menu 
                 break
             else
               puts "Invalid input try again".red 
             end 
             i += 1
         end 
        end 
        
        def clear_cards
            @@user_hand.clear
            @@dealer_hand.clear 
            @@user_img.clear
            @@dealer_img.clear
        end 
      
     def user_turn
       if score_in_hand(@@dealer_hand) == 21
        dealer_21
       end
        if score_in_hand(@@user_hand) < 21
        puts "Type hit for another card  or stay to pass".green
          user_input = gets.chomp
          if user_input.downcase == "hit"
            hit(@@user_hand)
            display_dealer_hand
            display_user_hand
            user_turn
          elsif user_input.downcase == "stay"
            dealer_turn
          else
            puts "Invalid input try again".red 
              user_turn
          end 
        elsif score_in_hand(@@user_hand) == 21
          user_21
        else
          bust
        end
     end
        
    def dealer_turn
      if score_in_hand(@@dealer_hand) < 17 
        hit(@@dealer_hand) 
        dealer_turn
      elsif score_in_hand(@@dealer_hand) >=17 && score_in_hand(@@dealer_hand) <= 21
        display_final_dealer_hand
        comparison_to_user
      else
       dealer_bust_payout 
      end
    end

    def dealer_bust_payout
      system("clear")
      display_final_dealer_hand
      puts "The deals is lame and sucks at blackjack so he busted".green 
      @@current_user[0].balance += @@bet
      puts ""
      puts "You are rich and won $#{@@bet}. Your total balance is: $#{@@current_user[0].balance}".green 
      puts "start a new game? y/n".green
         i = 1
         while i < 5
             user_input = gets.chomp
             if user_input.downcase == "y" 
                 system("clear")
                 start_game 
                 break
             elsif user_input.downcase == "n"
                 system("clear")
                 main_menu 
                 break
             else
               puts "Invalid input try again".red 
             end 
             i += 1
         end
    end

    def you_won_payout
      system("clear")
      puts "YOU ROCK!".yellow 
      display_user_hand
      puts ""
      display_final_dealer_hand
      @@current_user[0].balance += @@bet
      puts ""
      puts "You won $#{@@bet}. Your total is $#{@@current_user[0].balance}".green
      puts ""
      puts "start a new game? y/n".green
         i = 1
         while i < 5
             user_input = gets.chomp
             if user_input.downcase == "y" 
                 system("clear")
                 start_game 
                 break
             elsif user_input.downcase == "n"
                 system("clear")
                 main_menu 
                 break
             else
               puts "Invalid input try again".red 
             end 
             i += 1
         end
    end
    
    def comparison_to_user
      if score_in_hand(@@user_hand) == score_in_hand(@@dealer_hand)
        push
      elsif score_in_hand(@@user_hand) > score_in_hand(@@dealer_hand)
        you_won_payout
      else
        you_lost_loser
      end
    end

    def push
      system("clear")
      puts "Your hands were the same you get your money back".green
      puts ""
      puts "start a new game? y/n".green
         i = 1
         while i < 5
             user_input = gets.chomp
             if user_input.downcase == "y" 
                 system("clear")
                 start_game 
                 break
             elsif user_input.downcase == "n"
                 system("clear")
                 main_menu 
                 break
             else
               puts "Invalid input try again".red 
             end 
             i += 1
         end
    end
    
    def you_lost_loser
      system("clear")
      puts "Better luck next time!".yellow
      display_final_dealer_hand
      new_balance = @@current_user[0].balance - @@bet 
      puts ""
      puts "Your current balance is $#{@@current_user[0].balance}".green 
         @@current_user[0].balance = new_balance 
         puts "start a new game? y/n".green
         i = 1
         while i < 5
             user_input = gets.chomp
             if user_input.downcase == "y" 
                 system("clear")
                 start_game 
                 break
             elsif user_input.downcase == "n"
                 system("clear")
                 main_menu 
                 break
             else
               puts "Invalid input try again".red 
             end 
             i += 1
         end
    end
    
    def user_21
      system("clear")
      puts "You got BLACKJACK!".blue 
      puts "You win double".green 
      display_user_hand
      puts ""
      display_final_dealer_hand
      @@current_user[0].balance += (@@bet*2)
      puts ""
      puts "You won $#{@@bet*2}. Your total is $#{@@current_user[0].balance}".green 
      puts ""
      puts "start a new game? y/n".green
         i = 1
         while i < 5
             user_input = gets.chomp
             if user_input.downcase == "y" 
                 system("clear")
                 start_game 
                 break
             elsif user_input.downcase == "n"
                 system("clear")
                 main_menu 
                 break
             else
               puts "Invalid input try again".red 
             end 
             i += 1
         end
    end

    def dealer_21
      system("clear")
      puts "Dealer so total pwned you".red
      display_final_dealer_hand
      puts ""
      new_balance = @@current_user[0].balance - @@bet 

      puts ""
      puts "Your current balance is $#{@@current_user[0].balance}".green 
         @@current_user[0].balance = new_balance 
         puts "start a new game? y/n".green
         i = 1
         while i < 5
             user_input = gets.chomp
             if user_input.downcase == "y" 
                 system("clear")
                 start_game 
                 break
             elsif user_input.downcase == "n"
                 system("clear")
                 main_menu 
                 break
             else
               puts "Invalid input try again".red 
             end 
             i += 1
         end

    end
end
