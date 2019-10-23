require_relative './config/environment'
require 'pry'

class Cli 

    @@current_user = nil 

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
<<<<<<< HEAD
        user = User.where(user_name: username.capitalize)
        if user 
            # @@current_user = user
            puts "Welcome back!"
            puts "Username: #{user[0].user_name}, Balance: $#{user[0].balance}"
        else
            # binding.pry 
=======
        if User.where(user_name: username.capitalize) == []
>>>>>>> 9f98a8000f3b87198c53bb8be2e54779ac2118f1
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
<<<<<<< HEAD
        if username == User.where(user_name: username.capitalize) 
            puts "Username already exists, try again." 
            sign_up
        else 
            @@current_user = User.create(user_name: username.capitalize, balance: 1000) 
            sign_up                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
            # binding.pry
            # system('clear')
            # summary_page
        end 
    end 
    
    # def summary_page
    #     puts "Username: #{@@current_user.user_name.capitalize}, Balance: $#{@@current_user.balance}"
    #     puts "back to main menu y/n"
    #     i = 1
    #     while i < 5
    #         username1 = gets.chomp
    #         if username1.downcase == "y" 
    #             system("clear")
    #             main_menu
    #         elsif username1.downcase == "n"
    #             puts "tough luck"
    #             main_menu
    #         else
    #             puts "invalid input try again" 
    #         end 
    #         i += 1
    #     end 
    #     system("clear")
    #     main_menu
=======
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
>>>>>>> 9f98a8000f3b87198c53bb8be2e54779ac2118f1
        
    # end

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
	
    end

    def shuffle_deck

    end
    # def eval_hand_return_num(hand)
	
    # end

    # def bust
	
    # end

    # def score_in_hand

    # end

    # def display_hand

    # end

    # def display_dealer_hand

    # end
    
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
