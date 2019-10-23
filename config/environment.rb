require 'sinatra/activerecord'
require 'sqlite3'
require 'require_all'
require 'pry'
require 'rest-client' #might not need 

require_all 'lib' 



ActiveRecord::Base.logger = nil

shuffle = RestClient.get('https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6')
shuffle_j = JSON.parse(shuffle)
deck_id = shuffle_j["deck_id"]

draw_a_card = RestClient.get("https://deckofcardsapi.com/api/deck/#{deck_id}/draw/?count=2")
draw_cards_j = JSON.parse(draw_a_card)

reshuffle = RestClient.get("https://deckofcardsapi.com/api/deck/#{deck_id}/shuffle/")
reshuffle_j = JSON.parse(reshuffle)


binding.pry 
0