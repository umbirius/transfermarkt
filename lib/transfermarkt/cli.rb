#CLI controller 

class Transfermarkt::CLIO
  error = Pastel.new
  
  def initialize 
    puts "Welcome to the Transfer-market!"
    #create prompts? 
  end 

  def call
    error = Pastel.new
    start
    while @selection != ""
      if @selection == "next"
        # && Transfermarkt::Scraper.next_url == true
        if Transfermarkt::Player.all.length == (@id + 10)
          make_additional_players
          display_next_page
        else
          display_next_page
        end 
      # elsif @selection == "next" && Transfermarkt::Scraper.next_url == nil
      #   puts error.red("There are no additional results. \nSelect 'back' or a player's name.")
      #   display_page
      elsif @selection == "back"
        if @id > 9
          display_previous_page
        else 
          display_page
          puts error.red("You are on the first page.\nSelect 'next' or a player's name.")
        end 
      else 
        add_player_bio
        display_player_info
        choice = reccur?
          if choice == "y"
            Transfermarkt::Player.reset
            start 
          elsif choice == "n"
            goodbye
            return
          else
            puts error.("Please enter 'y' or 'n'")
          end
      end 
    end 
  end 
  
  def input
    prompt1 = TTY::Prompt.new
    @query = prompt1.ask("Enter a player:")
  end 

  def start 
    input
    make_players
    @prompt = TTY::Prompt.new
    choices  = (Transfermarkt::Player.all.map.with_index(1) {|player, i| "#{i}. #{player.name}"})
    choices += ["next","back"]
    @selection = @prompt.select("Choose your player?", choices, help: "Press 'enter' to select", symbols: {marker: '>'})
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
    display_page
  end 
  
  def display_previous_page
    @id -= 10
    display_page
  end 
    
  def display_page
    choices = Transfermarkt::Player.all.slice(@id..(@id+9)).map.with_index(@id + 1) do |player, i|
      "#{i}. #{player.name}"
    end 
    choices += ["next","back"] 
    @selection = @prompt.select("Choose your player?", choices, help: "Press 'enter' to select", symbols: {marker: '>'})
  end 
  
  def add_player_bio 
    selection_i = @selection.delete('^0-9').to_i
    @player =  Transfermarkt::Player.all[selection_i - 1]
    add_attr_hash = Transfermarkt::Scraper.player_profile(@player)
    @player.add_attributes(add_attr_hash)
    @player
  end 
    
  def display_player_info
    puts"------------------#{@player.header}---------------------"

    puts "DOB:                     #{@player.date_of_birth}"
    puts "Birth Place:             #{@player.place_of_birth_city}, #{@player.place_of_birth_country}"
    puts "Age:                     #{@player.age}"
    puts "Height:                  #{@player.height}"
    puts "Position:                #{@player.position}"
    puts "Preffered Foot:          #{@player.foot}"
    puts "Agent:                   #{@player.agents}"
    puts "Club:                    #{@player.club}"
    puts "Date Joined:             #{@player.date_joined}"
    puts "Contract Until:          #{@player.contract_exp}"
    puts "Athletic Sponsor:        #{@player.sponsor}"
    puts "Current Market Value:    #{@player.current_market_value}"
    puts "Last Updated:            #{@player.date_current_market_value}"
    puts "Hightest Market Value:   #{@player.highest_market_value}"
    puts "Date:                    #{@player.date_highest_market_value}"
  end 
  
  def reccur?
    prompt_recurr = TTY::Prompt.new
    input = prompt_recurr.ask("Would you like to search again (y/n)?")
    input.strip.downcase
  end 
  
  def goodbye 
    puts "Thanks for stopping by."
    puts "Come back again soon to see the values of all your favorite players!"
  end 

end 



class Transfermarkt::CLI 
  
  def call 
    # welcome
    # choose
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
  
  def add_player_bio 
    add_attr_hash = Transfermarkt::Scraper.player_profile(@player)
    @player.add_attributes(add_attr_hash)
    @player
  end 
    
  def display_player_info
    puts"------------------#{@player.header}---------------------"
    puts "DOB:                     #{@player.date_of_birth}"
    puts "Birth Place:             #{@player.place_of_birth_city}, #{@player.place_of_birth_country}"
    puts "Age:                     #{@player.age}"
    puts "Height:                  #{@player.height}"
    puts "Position:                #{@player.position}"
    puts "Preffered Foot:          #{@player.foot}"
    puts "Agent:                   #{@player.agents}"
    puts "Club:                    #{@player.club}"
    puts "Date Joined:             #{@player.date_joined}"
    puts "Contract Until:          #{@player.contract_exp}"
    puts "Last Contract Ext.:      #{@player.last_contract_ext}"
    puts "Athletic Sponsor:        #{@player.sponsor}"
    puts "Current Market Value:    #{@player.current_market_value}"
    puts "Last Updated:            #{@player.date_current_market_value}"
    puts "Hightest Market Value:   #{@player.highest_market_value}"
    puts "Date:                    #{@player.date_highest_market_value}"
  end 
  
  def make_additional_players
    next_page_player_array = Transfermarkt::Scraper.scrape_next_page
    Transfermarkt::Player.create_from_collection(next_page_player_array)
  end 
  
  def 
  
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
  
  
  
  
  
  def menu 

    input = ''
    while input != "exit"
      input == ''
      puts "Enter the number of the player you'd like more info on:"    
      input = gets.strip.downcase

      
      if input.to_i > 0 
        @player =  Transfermarkt::Player.all[input.to_i - 1]
        add_player_bio
        display_player_info
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
        puts "Type 'h' for help"
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

class Transfermarkt::CLIX
  error = Pastel.new
  
  def initialize 
    puts "Welcome to the Transfer-market!"
    #create prompts? 
  end 

  def call
    error = Pastel.new
    @input = ''
    start
    while @input != ""
      if @input.to_i > 0
        add_player_bio
        display_player_info
        reccur?
        if @input == "y"
          start 
        elsif @input =="n"
          goodbye
          break
        else 
          puts "Please enter 'y' or 'n'"
          reccur?
        end 
      elsif @input == "next" 
        if Transfermarkt::Player.all.length == (@id+10)
          make_additional_players
          display_next_page
        
        else 
          display_next_page
        end 
      elsif @input == "back"
        display_previous_page
      elsif @input == "exit"
        goodbye 
        break
      else 
        puts "Please enter valid option"
  
      end 
    end 
  end 
  
  def start 
    puts "Enter a player: "
    @query = gets.strip
    make_players    
    display_first_page
  end 

  def make_players
    Transfermarkt::Scraper.set_doc(@query)
    players_array = Transfermarkt::Scraper.scrape_players
    Transfermarkt::Player.create_from_collection(players_array)
  end 
  
  def make_additional_players
    next_page_player_array = Transfermarkt::Scraper.scrape_next_page
    Transfermarkt::Player.create_from_collection(next_page_player_array)
  end 
  
  def display_first_page
    @id = 0
  display_page
  end 
  
  def display_next_page
    @id += 10
    display_page
  end 
  
  def display_previous_page
    @id -= 10
    display_page
  end 
    
  def display_page
    choices = Transfermarkt::Player.all.slice(@id..(@id+9)).map.with_index(@id + 1) do |player, i|
      "#{i}. #{player.name}"
    end 
    choices.each {|c| puts c}
    puts "Pick a player you would like more info on. \n next- for next page \n back- for last page \n exit- leave program"
    @input = gets.strip
  end 
  
  def add_player_bio 
    @player =  Transfermarkt::Player.all[@input.to_i - 1]
    add_attr_hash = Transfermarkt::Scraper.player_profile(@player)
    @player.add_attributes(add_attr_hash)
    @player
  end 
    
  def display_player_info
    puts"------------------#{@player.header}---------------------"

    puts "DOB:                     #{@player.date_of_birth}"
    puts "Birth Place:             #{@player.place_of_birth_city}, #{@player.place_of_birth_country}"
    puts "Age:                     #{@player.age}"
    puts "Height:                  #{@player.height}"
    puts "Position:                #{@player.position}"
    puts "Preffered Foot:          #{@player.foot}"
    puts "Agent:                   #{@player.agents}"
    puts "Club:                    #{@player.club}"
    puts "Date Joined:             #{@player.date_joined}"
    puts "Contract Until:          #{@player.contract_exp}"
    puts "Athletic Sponsor:        #{@player.sponsor}"
    puts "Current Market Value:    #{@player.current_market_value}"
    puts "Last Updated:            #{@player.date_current_market_value}"
    puts "Hightest Market Value:   #{@player.highest_market_value}"
    puts "Date:                    #{@player.date_highest_market_value}"
  end 
  
  def reccur?
    prompt_recurr = TTY::Prompt.new
    puts "Would you like to search again (y/n)?"
    @input = gets.strip.downcase
  end 
  
  def goodbye 
    puts "Thanks for stopping by."
    puts "Come back again soon to see the values of all your favorite players!"
  end 

  
end 