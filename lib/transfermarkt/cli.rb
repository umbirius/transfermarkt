#CLI controller 

class Transfermarkt::CLI 
  
  def call 
    list_players_names
    menu 
    goodbye
  end 
  
  def list_players_names
    @players = Transfermarkt::Player.player
    puts "NO. --  Name ----- POS ----- Club --- Age -- NAT ---- MV --- Agent ---"
    @players.each.with_index(1) do |player, i| 
      puts "#{i}. #{player.name} - #{player.position} - #{player.club} - #{player.age} - #{player.nationality} - #{player.market_value} - #{player.agents}"
    end 
  end
  
  def menu 

    input = ''
    while input != "exit"
    puts "Enter the number of the player you'd like more info on"    
      input = gets.strip.downcase
      if input.to_i > 0 
        @players[input.to_i - 1]
      elsif "list"
        list_players_names
      else 
        "Enter list or exit"
      end 
    end 
  end 
  
  def goodbye 
    puts "Until next time" 
  end 
end 