#CLI controller 

class Transfermarkt::CLI 
  
  def call 
    list_players_names
    menu 
    goodbye
  end 
  
  def list_players_names
    puts "players"
    puts "Team"
  end
  
  def menu 

    input = ''
    while input != "exit"
    puts "Enter the number of the player you'd like more info on"    
      input = gets.strip.downcase
      if input == "1"
        puts "one"
      elsif input == "2"
        puts "two"
      elsif "list"
        list_players_names
      end 
    end 
  end 
  
  def goodbye 
    puts "Until next time" 
  end 
end 