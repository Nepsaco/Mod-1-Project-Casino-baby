class CreateResultsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :results do |t|
      t.references :user, foreign_key: true 
      t.references :blackjack, foreign_key: true 
      t.integer :pot 
    end 
  end
end
