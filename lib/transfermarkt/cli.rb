#CLI controller 

class Transfermarkt::CLI 
  
  def call 
    welcome
    choose
    input
    make_players
    display_players
    menu 
    goodbye
  end 
  
  def welcome
    puts "Welcome to the Transfermarket!"
    puts "How much is your favorite player worth?"
    puts "Type next to continue"
    input = ''
    while input != "next"
      input = gets.strip.downcase
    end 
    
  end 
  
  def choose 
    puts "Select one of the following options:"
    puts "1: List of most expensive players"
    puts "2: Search player by name"
    @option = gets.strip.to_i
    if @option == 1
      puts "most expensive player list"
    elsif @option == 2
      puts "search"
    else 
      puts "please select from the list"
    end 
  end 
  
  def input
    puts "Please enter a player:"
    @query = gets.strip 
  end 
  
  
  def make_players
    @id = 0
    Transfermarkt::Scraper.set_doc(@query)
    players_array = Transfermarkt::Scraper.scrape_players
    Transfermarkt::Player.create_from_collection(players_array)
  end 
  
  def make_additional_players
    next_page_player_array = Transfermarkt::Scraper.scrape_next_page
    Transfermarkt::Player.create_from_collection(next_page_player_array)
  end 
  
  def display_next_page
    @id += 10
    Transfermarkt::Player.all.drop(@id).each.with_index(@id + 1) do |player, i|
      break if i > (@id + 10)
      puts "#{i}. #{player.name} - #{player.position} - #{player.club} - #{player.age} - #{player.nationality} - #{player.market_value} - #{player.agents}"
    end 
    
  end 
  
  def display_previous_page
    @id -= 10
    Transfermarkt::Player.all.drop(@id).each.with_index(@id + 1) do |player, i|
      break if i > (@id + 10)
      puts "#{i}. #{player.name} - #{player.position} - #{player.club} - #{player.age} - #{player.nationality} - #{player.market_value} - #{player.agents}"
    end 
  end 
    
  def display_current_page
    Transfermarkt::Player.all.drop(@id).each.with_index(@id + 1) do |player, i|
      break if i > (@id + 10)
      puts "#{i}. #{player.name} - #{player.position} - #{player.club} - #{player.age} - #{player.nationality} - #{player.market_value} - #{player.agents}"
    end 
  end 
  
  def display_players 
    puts "Results:"
    # rows = []
    Transfermarkt::Player.all.each.with_index(1) do |player, i|
      # rows << puts ["#{i}. ", player.name, player.position, player.club, player.age, player.nationality, player.market_value, player.agents]
      puts "#{i}. #{player.name} - #{player.position} - #{player.club} - #{player.age} - #{player.nationality} - #{player.market_value} - #{player.agents}"
    end
    # table = Terminal::Table.new :rows => rows
    # puts table
  end 
  
  def select_category_results
    puts "please select which results you would like: players, managers/staff, or team"
    input = gets.strip
  end 
  
  
  def menu 

    input = ''
    while input != "exit"
      puts "Enter the number of the player you'd like more info on:"    
      input = gets.strip.downcase
     
      if input.to_i > 0 
        the_player =  Transfermarkt::Player.all[input.to_i - 1]
        puts Transfermarkt::Scraper.player_profile_url(the_player)
      elsif input == "next" 
        if Transfermarkt::Player.all.length == (@id + 10)
          make_additional_players
          display_next_page
        else 
          display_next_page
        end 
      elsif input == "back"
        if @id > 9
          display_previous_page
        else 
          display_current_page
          puts "Please select a valid option."
          puts "Type '-h' for help" 
        end
      elsif input == "list"
        display_current_page
      elsif input == "-h"
        help 
      elsif input != "exit" 
        puts "Please select a valid option."
        puts "Type '-h' for help"
      end 
    end 
  end 
  
  def goodbye 
    puts "May your favorite soccer player's stock continue to rise!, until next time!" 
  end 
  
  def help 
    puts "Input number to generate more information on a player"
    puts "exit - to escape"
    puts "next - shows next page of results"
    puts "back - shows last page of results"
    puts "list - shows current search results"
  end 
  
end 