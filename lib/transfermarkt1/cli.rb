#CLI controller 

class Transfermarkt::CLI 
  
  def call 
    list_players_names
    list_results
    select_category_results
    menu 
    goodbye
  end 
  
  
  def input
    puts "please enter name of player, managers/staff, or team"
    input = gets.strip 
  end 
  
  def list_results 
  end 
  
  def select_category_results
    puts "please select which results you would like: players, managers/staff, or team"
    input = gets.strip
  end 
  
  def list_players_names
    @players = Transfermarkt::Player.players
    puts "NO. --  Name ----- POS ----- Club --- Age -- NAT ---- MV --- Agent ---"
    @players.each.with_index(1) do |player, i| 
      puts "#{i}. #{player.values[0]} - #{player.values[1]} - #{player.values[2]} - #{player.values[3]} - #{player.values[4]} - #{player.values[5]} - #{player.values[6]}"
    end 
  end
  
  def menu 

    input = ''
    while input != "exit"
    puts "Enter the number of the player you'd like more info on"    
      input = gets.strip.downcase
     
      if input.to_i > 0 
       the_player =  @players[input.to_i - 1]
       puts the_player.name
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