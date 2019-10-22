require_relative './config/environment'
require 'pry'

class Cli 
    def welcome
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
            sign_up    
            when 3
            leaderboard    
            when 4
                exit game
            else 
                puts "Invalid input, try again" 
                main_menu
                
        end
    end

    def login 
        puts "Type in Username"
        username = gets.chomp 
        if User.where(user_name: username)
            puts "Welcome back!"
            puts "Username: #{username.capitalize}, Balance: $#{balance}"
        else 
            puts "sorry you don't exist!"
            main_menu
        end 
    end 


    def sign_up 
        puts "Type in a Username."
        username = gets.chomp 
        if User.where(user_name: username) 
            puts "Username already exists, try again." 
            sign_up
        else 
            new_user = User.create(user_name: username, balance: 1000) 
            puts "Username: #{username.capitalize}, Balance: $#{new_user.balance}"
        end 
    end 

    def leaderboard 
        leaderboard_counter = 1
        money = User.pluck(:balance)   #all.map {|user| user.balance}.sort.reverse 
        while money.length >= leaderboard_counter  
            puts "#{leaderboard_counter}. #{User.all[leaderboard_counter-1].user_name}: $#{User.all[leaderboard_counter-1].balance}" 
            leaderboard_counter += 1  
        end 

    end 


    # binding.pry
    # 0 
end 