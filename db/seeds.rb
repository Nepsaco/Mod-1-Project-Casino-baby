User.destroy_all
Blackjack.destroy_all
Result.destroy_all


tobie = User.create(user_name: "Tobie", balance: 2000)
adam = User.create(user_name: "Adam", balance: 1500)
amy = User.create(user_name: "Amy", balance: 250)

