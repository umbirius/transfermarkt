class Transfermarkt::Player 
  
  attr_accessor :name, :position, :club, :age, :nationality, :market_value, :agents 
  

  
  def self.player 
  
  player1 = self.new 
  player1.name = "stefan grizni"
  player1.position = "CB"
  player1.club = "Barcelona"
  player1.age = "14"
  player1.nationality = "Brazil"
  player1.market_value = "$12"
  player1.agents = "mino raiola"
  
  player2 = self.new 
  player2.name = "moris lopez"
  player2.position = "CF"
  player2.club = "Vasco De Gama"
  player2.age = "15"
  player2.nationality = "Uruguay"
  player2.market_value = "$3.50"
  player2.agents = "sergio mendes"
  
  [player1, player2]
  end
  
end 