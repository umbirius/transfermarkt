#CLI controller 

class Transfermarkt::CLI 
  
  def call 
    list_player_info
    menu 
  end 
  
  def list_player_info 
    puts "player info"
    puts "Team: , Goals: , Value: "
  end
  
  def menu 
    puts "Enter the number of the player you'd like more info on"
  end 
end 