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
                if username1.downcase == "y" 
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
        score_in_hand
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

    def score_in_hand
        total = @@user_hand.reduce(0) do |sum, card|
            binding.pry
                case card
                    when "2H"||"2S"||"2C"||"2D"
                        sum + 2
                    when "3H"||"3S"||"3C"||"3D"
                        sum + 3
                    when "4H"||"4S"||"4C"||"4D"
                        sum + 4
                    when "5H"||"5S"||"5C"||"5D"
                        sum + 5
                    when "6H"||"6S"||"6C"||"6D"
                        sum + 6
                    when "7H"||"7S"||"7C"||"7D"
                        sum + 7
                    when "8H"||"8S"||"8C"||"8D"
                        sum + 8
                    when "9H"||"9S"||"9C"||"9D"
                        sum + 9
                    when "10H"||"10S"||"10C"||"10D"
                        sum + 10
                    when "JH"||"JS"||"JC"||"JD"
                        sum + 10
                    when "QH"||"QS"||"QC"||"QD"
                        sum + 10
                    when "KH"||"KS"||"KC"||"KD"
                        sum + 10
                    when "AH"||"AS"||"AC"||"AD"
                        sum + 1
                end
            end
        total
    end
    cli = Cli.new
a = cli.start_game

def display_hand
    puts "#{@@user_hand}"
    end

    def display_dealer_hand
        puts "#{@@dealer_hand[1]}" 

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
