require_relative './config/environment'
require 'pry'

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
	case user_input
		when 1
		 login 
		when 2
 		 go to sign up page
		when 3
         got to leaderboards 
        when 4
            exit game
	end
end

def login 
    
end 

def leaderboard 
    leaderboard_counter = 1
    money = User.all.map {|user| user.balance}.sort.reverse 
    while money.length >= leaderboard_counter  
        puts "#{leaderboard_counter}. #{User.all[leaderboard_counter-1].user_name}: $#{User.all[leaderboard_counter-1].balance}" 
        leaderboard_counter += 1 
    end 
end 

def sign_up 

end 



# binding.pry
# 0 