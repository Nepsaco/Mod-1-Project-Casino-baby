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
                exit game
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
        user = User.where(user_name: username.capitalize)
        if user == true 
            @@current_user = user
            puts "Welcome back!"
            puts "Username: #{user[0].user_name}, Balance: $#{user[0].balance}"
        else
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
        end 
    end 


    def sign_up 
        puts "Type in your first name."
        username = gets.chomp 
        if username == User.where(user_name: username.capitalize) 
            puts "Username already exists, try again." 
            sign_up
        else 
            @@current_user = User.create(user_name: username.capitalize, balance: 1000)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
            # binding.pry
            system('clear')
            summary_page
        end 
    end 
    
    def summary_page(current_user)
        puts "Username: #{@@current_user.user_name.capitalize}, Balance: $#{self.balance}"
        
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


    # binding.pry
    # 0 
end 