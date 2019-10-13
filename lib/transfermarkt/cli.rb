#CLI controller 

class Transfermarkt::CLI
  error = Pastel.new
  
  def initialize 
    @error = Pastel.new
    @prompt = Pastel.new
    puts @prompt.yellow.bold.underline("Welcome to the Transfer-market!")
  end 
  
  def error 
    puts @error.red("Please enter valid option.")
    @input = gets.strip
  end

  def call
    @input = ''
    start
    while @input != "exit"
      if @input.to_i > @id && @input.to_i < ((Transfermarkt::Player.all.length) +1)
        add_player_bio
        display_player_info
        reccur?
        while @input != 'y' || @input != 'n'
          if @input == "y"
            Transfermarkt::Player.reset
            start
            break
          elsif @input =="n"
            goodbye
            return
          else 
            puts @error.red("Please enter 'y' or 'n'")
            reccur?
          end 
        end 
      elsif @input == "next" && Transfermarkt::Scraper.next_url != nil
        if Transfermarkt::Player.all.length == (@id+10)
          make_additional_players
          display_next_page
        else 
          display_next_page
        end
      elsif @input == "next" && Transfermarkt::Scraper.next_url == nil
        puts @error.red("There are no additional results.")
        error
      elsif @input == "back"
        if @id > 9
          display_previous_page
        else
          puts @error.red("You are on the first page.")
          error
        end 
      else
        error
      end 
    end 
    goodbye
  end 
  
  def start
    while @query != ""
      puts @prompt.yellow("Enter a player: ")
      @query = gets.strip
      make_players
      if Transfermarkt::Player.all.length > 0
        display_first_page
        break
      else
        puts @error.red("There are no valid search results. Try again.")
      end 
    end

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
    puts @prompt.yellow.bold.underline("        Results         ")
    choices.each {|c| puts c}
    puts @prompt.yellow("Enter the number of a player you would like more info on.")
    puts @prompt.bright_magenta("next- for next page \nback- for previous page \nexit- leave program")
    @input = gets.strip
  end 
  
  def add_player_bio 
    @player =  Transfermarkt::Player.all[@input.to_i - 1]
    add_attr_hash = Transfermarkt::Scraper.player_profile(@player)
    @player.add_attributes(add_attr_hash)
    @player
  end 
    
  def display_player_info
    display = @prompt.blue.bold.detach
    display2 = @prompt.white.detach
    puts @prompt.yellow.bold.underline("-----------------#{@player.header}-----------------")
    puts (display.("DOB:                     ") + display2.("#{@player.date_of_birth}"))
    puts (display.("Birth Place:             ") + display2.("#{@player.place_of_birth_city}, #{@player.place_of_birth_country}"))
    puts (display.("Age:                     ") + display2.("#{@player.age}"))
    puts (display.("Height:                  ") + display2.("#{@player.height}"))
    puts (display.("Position:                ") + display2.("#{@player.position}"))
    puts (display.("Preffered Foot:          ") + display2.("#{@player.foot}"))
    puts (display.("Agent:                   ") + display2.("#{@player.agents}"))
    puts (display.("Club:                    ") + display2.("#{@player.club}"))
    puts (display.("Date Joined:             ") + display2.("#{@player.date_joined}"))
    puts (display.("Contract Until:          ") + display2.("#{@player.contract_exp}"))
    puts (display.("Athletic Sponsor:        ") + display2.("#{@player.sponsor}"))
    puts (display.("Current Market Value:    ") + display2.("#{@player.current_market_value}"))
    puts (display.("Last Updated:            ") + display2.("#{@player.date_current_market_value}"))
    puts (display.("Hightest Market Value:   ") + display2.("#{@player.highest_market_value}"))
    puts (display.("Date:                    ") + display2.("#{@player.date_highest_market_value}"))
  end 
  
  def reccur?
    puts @prompt.yellow("Would you like to search again (y/n)?")
    @input = gets.strip.downcase
  end 
  
  def goodbye 
    puts @prompt.yellow("Thanks for stopping by.")
    puts @prompt.yellow("Come back again soon to see the values of all your favorite players!")
  end 

  
end 