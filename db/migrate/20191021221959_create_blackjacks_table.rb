class CreateBlackjacksTable < ActiveRecord::Migration[6.0]
  def change
    create_table :blackjacks do |t|
      t.string :dealer_cards
      t.string :player_cards
      t.integer :dealer_card_total
      t.integer :player_card_total 
      t.string :next_card 
    end 
  end
end
