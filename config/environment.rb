require 'sinatra/activerecord'
require 'sqlite3'
require 'require_all'
require 'pry'

require_all 'lib' 

def Welcome
	puts "Welcome!"
	puts "logo"
end

def main_menu
	puts 'Pick an option'
	puts '1. login'
	puts '2. sign up'
	puts '3. exit'
	user_input = gets.strip
	case user_input
		when 1
		 go to login page
		when 2
 		 go to sign up page
		when 3
		 exit game
	end
end
binding.pry
0 

