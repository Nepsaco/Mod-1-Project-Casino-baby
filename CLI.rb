require_relative './config/environment'
require 'pry'

class Cli 

    @@current_user = nil 
    @@deck_id = nil 
    @@dealer_hand = []
    @@user_hand = [] 
     

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
        shuffle_deck
        deal_card
        initial_deal 
        display_user_hand
        binding.pry
        display_dealer_hand
        score = score_in_hand(@@user_hand)
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

    def initial_deal
        card = deal_card 
        @@user_hand << card["cards"][0]["code"] 
        card = deal_card
        @@dealer_hand << card["cards"][0]["code"] 
        card = deal_card
        @@user_hand << card["cards"][0]["code"] 
        card = deal_card
        @@dealer_hand << card["cards"][0]["code"] 
    end 
    
    # def eval_hand_return_num(hand)
	
    # end

    # def bust
	
    # end
    def numeric?(lookAhead)
        lookAhead =~ /[[:digit:]]/
    end

    def score_in_hand(hand) 
        # i = 0
        # total = []
        hand.reduce(0) do |sum, card|
            first_character = card.split('').first
            # binding.pry
            if numeric?(first_character)
                sum += first_character.to_i
            else
                face_cards = {"J" => 10, "Q" => 10, "K" => 10, "A" => 1}
                sum += face_cards[first_character.to_s]
            end
            
        end
        # while i < @@user_hand.length
        #     case @@user_hand[i]
        #         when "2H"||"2S"||"2C"||"2D" 
        #             @total << 2
        #             return @total
        #         when "3H"||"3S"||"3C"||"3D" 
        #             @total << 3
        #             return @total
        #         when "4H"||"4S"||"4C"||"4D" 
        #             @total << 4
        #             return @total
        #         when "5H"||"5S"||"5C"||"5D" 
        #             @total << 5
        #             return @total
        #         when "6H"||"6S"||"6C"||"6D" 
        #             @total << 6
        #             return @total
        #         when "7H"||"7S"||"7C"||"7D" 
        #             @total << 7
        #             return @total
        #         when "8H"||"8S"||"8C"||"8D" 
        #             @total << 8
        #             return @total
        #         when "9H"||"9S"||"9C"||"9D" 
        #             @total << 9
        #             return @total
        #         when "0H"||"0S"||"0C"||"0D" 
        #             @total << 10
        #             return @total
        #         when "JH"||"JS"||"JC"||"JD" 
        #             @total << 10
        #             return @total
        #         when "QH"||"QS"||"QC"||"QD" 
        #             @total << 10
        #             return @total
        #         when "KH"||"KS"||"KC"||"KD" 
        #             @total << 10
        #             return @total
        #         when "AH"||"AS"||"AC"||"AD" 
        #             @total << 1
        #             return @total
        #     end
        #             i += 1
        # end
        # binding.pry
        # total
    end
    # binding.pry

    # def values
        
    # end
  

    def display_user_hand
        i = 0
        while i < @@user_hand.length
            puts "#{@@user_hand[i]}"
            i+= 1
        end
        card_total = score_in_hand(@@user_hand)
        puts "Your Total is: #{card_total}"
    end

    def display_dealer_hand
        i = 1
        while i < @@dealer_hand.length
            puts "#{@@dealer_hand[i]}" 
            i +=1
        end
        puts ""
    end 
    
    # def set_bet
    # end
    # def betting_time

    # end

    # def play_time

    # end

    # def hit
    # end

    # def stay
    # end

    # def quit
    # end

end

cli = Cli.new
a = cli.start_game
