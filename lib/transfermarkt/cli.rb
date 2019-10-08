#CLI controller 

class Transfermarkt::CLI 
  
  def call 
    input
    make_players
    display_players
    menu 
    goodbye
  end 
  
  
  def input
    puts "please enter name of player, managers/staff, or team"
    @query = gets.strip 
  end 
  
  
  def make_players
    Transfermarkt::Scraper.set_doc(@query)
    players_array = Transfermarkt::Scraper.scrape_players
    Transfermarkt::Player.create_from_collection(players_array)
  end 
  
  def make_additional_players
    next_page_player_array = Transfermarkt::Scraper.scrape_next_page
    binding.pry
    Transfermarkt::Player.create_from_collection(next_page_player_array)
  end 
  
  def display_next_page 
    Transfermarkt::Player.all.drop(10).each.with_index(11) do |player, i|
      puts "#{i}. #{player.name} - #{player.position} - #{player.club} - #{player.age} - #{player.nationality} - #{player.market_value} - #{player.agents}"
    end 
  end 
  
  def display_previous_page
  end 
    
  
  def display_players 
    Transfermarkt::Player.all.each.with_index(1) do |player, i|
      puts "#{i}. #{player.name} - #{player.position} - #{player.club} - #{player.age} - #{player.nationality} - #{player.market_value} - #{player.agents}"
    end 
  end 
  
  def select_category_results
    puts "please select which results you would like: players, managers/staff, or team"
    input = gets.strip
  end 
  
  # def list_players_names
  #   @players = Transfermarkt::Player.players
  #   puts "NO. --  Name ----- POS ----- Club --- Age -- NAT ---- MV --- Agent ---"
  #   @players.each.with_index(1) do |player, i| 
  #     puts "#{i}. #{player.values[0]} - #{player.values[1]} - #{player.values[2]} - #{player.values[3]} - #{player.values[4]} - #{player.values[5]} - #{player.values[6]}"
  #   end 
  # end
  
  def menu 

    input = ''
    while input != "exit"
      puts "Enter the number of the player you'd like more info on"    
      input = gets.strip.downcase
     
      if input.to_i > 0 
        the_player =  Transfermarkt::Player.all[input.to_i - 1]
        puts the_player.name
      elsif input == "next"
        make_additional_players
        display_next_page
      end 
    end 
  end 
  
  def goodbye 
    puts "May your favorite soccer player's stock continue to rise!, until next time!" 
  end 
  
end 