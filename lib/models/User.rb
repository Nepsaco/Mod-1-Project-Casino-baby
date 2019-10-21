class User < ActiveRecord::Base 
    has_many :results
    has_many :blackjacks, through: :results
end 