require_relative './config/environment'
require 'pry'

class Cli 

    @@current_user = nil 
    @@deck_id = nil 
    @@dealer_hand = []
    @@user_hand = []
    @@bet = 0 

    def welcome
        system("clear")
        puts "Welcome!"
        puts "logo"
    end

    def main_menu
        puts 'Pick an option'
        puts '1. login'
        puts '2. sign up'
        puts '3. leaderboard'
        puts '4. exit'
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
                puts "Invalid input, try again" 
                main_menu
        end
    end

    def login 
        system("clear")
        puts "Type in Username"
        username = gets.chomp 
        if User.where(user_name: username.capitalize) == []
            puts "sorry you don't exist! would you like to sign up? y/n"
            i = 1
            while i < 5
                username1 = gets.chomp
                if username1 == "y"
                    system("clear")
                    sign_up
                elsif username1.downcase == "n"
                    system("clear") 
                    main_menu
                else
                    puts "invalid input try again" 
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
        puts "Type in your first name."
        username = gets.chomp 
        if  User.where(user_name: username.capitalize)==[] 
	    @@current_user = User.create(user_name: username.capitalize, balance: 1000)
	    system('clear')
            summary_page
        else 
            puts "Username already exists, try again." 
            sign_up 
        end 
    end 
    
    def summary_page
        system("clear")
        puts "Username: #{@@current_user[0].user_name.capitalize}, Balance: $#{@@current_user[0].balance}"
        puts ""
        puts "To start game type y/n"
        puts ""
        puts "Type main menu to return"
        i = 1
        while i < 5
            username1 = gets.chomp
            if username1.downcase == "y" 
                system("clear")
                start_game               
            elsif username1.downcase == "n"
                summary_page
            elsif username1 == "main menu" 
                system("clear")
                main_menu
            else
                puts "invalid input try again" 
            end 
            i += 1
        end 
        system("clear")
        main_menu
        
    end

    def leaderboard 
        system("clear")
        i = 1
        money_leaderboard = User.order(balance: :desc)
        money_leaderboard.each do |user| 
            puts "#{i}. Username: #{user.user_name} Balance: $#{user.balance}"
            i += 1
        end
        puts ""
        puts ""
        puts "back to main menu y/n"
        i = 1
        while i < 5
            username1 = gets.chomp
            if username1.downcase == "y" 
                system("clear")
                main_menu
            elsif username1.downcase == "n"
                leaderboard
            else
                puts "invalid input try again" 
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
        binding.pry
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
        card = deal_card
        @@user_hand << card["cards"][0]["code"] 
    end 

    def initial_deal_dealer
        card = deal_card
        @@dealer_hand << card["cards"][0]["code"] 
        card = deal_card
        @@dealer_hand << card["cards"][0]["code"] 
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
                face_cards = {"J" => 10, "Q" => 10, "K" => 10, "A" => 1}
                sum += face_cards[first_character.to_s]

            end
        end
    end

    def display_user_hand
        puts "Your Hand:"
        i = 0
        while i < @@user_hand.length
            puts "#{@@user_hand[i]}"
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
            puts "#{@@dealer_hand[i]}" 
            i +=1
        end
        card_total = dealer_score_showing
        puts "Dealer Total is: #{card_total}"
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
                face_cards = {"J" => 10, "Q" => 10, "K" => 10, "A" => 1}
                sum += face_cards[first_character.to_s]
            end
        end
    end
    
    def set_bet
      puts "Enter bet amount! You have #{@@current_user[0].balance} to spend."
      user_input = gets.chomp
      if user_input.to_i > 0 && user_input.to_i <= @@current_user[0].balance 
        @@current_user[0].balance.to_i - user_input.to_i
        @@bet = user_input.to_i
      else
        puts "invalid input try again" 
        set_bet
      end
    end

    def hit
        new_card = deal_card["cards"][0]["code"]
        new_hand = @@user_hand << new_card
    end 


    def quit
        if @@user[0].balance <= 0
            system("clear")
            puts "Sorry you're out of money!"
            puts "back to main menu y/n"
            i = 1
            while i < 5
                no_money = gets.chomp
                if no_money.downcase == "y" 
                    system("clear")
                    main_menu
                elsif no_money.downcase == "n"
                    system("clear")
                    leaderboard
                else
                    puts "invalid input try again" 
                end 
                i += 1
            end 
        end 
    end 

        def bust 
         puts "you busted, you lost #{@@bet}"
         new_balance = @@current_user[0].balance - @@bet 
         @@current_user[0].balance = new_balance 
         puts "start a new game? y/n"
         i = 1
         while i < 5
             user_input = gets.chomp
             if user_input.downcase == "y" 
                 system("clear")
                 start_game 
             elsif user_input.downcase == "n"
                 system("clear")
                 main_menu 
             else
                 puts "invalid input try again" 
             end 
             i += 1
         end 
        end 
        
        def clear_cards
            @@user_hand.clear
            @@dealer_hand.clear 
        end 
      
         def user_turn
        i = 0
        if score_in_hand(@@user_hand) < 21
        puts "Type hit for another card  or stay to pass"
        user_input = gets.chomp
        while i < 5
          if user_input.downcase == "hit"
            hit
            dealer_turn
          elsif user_input.downcase == "stay"
            dealer_turn
          else
                puts "invalid input try again" 
                i += 1
          end 
        end      
        elsif score_in_hand(@@user_hand) == 21
          you_won_payout
        else
          bust
        end
    end
        
    def dealer_turn
      if score_in_hand(@@dealer_hand) < 17 
        hit 
      elsif score_in_hand(@@dealer_hand) >=17 && score_in_hand(@@dealer_hand) <= 21
        stay
      else
       dealer_bust_payout 
      end
    end
    
    def round 
      if
        user_turn
        dealer_turn
      end
    end
end
# a = Cli.new
# a.start_game
