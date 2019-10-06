class Transfermarkt::Player 
  
  attr_accessor :name, :position, :club, :age, :nationality, :market_value, :agents 
  

  
  def self.players #change name  
    
    self.scrape_players
  end 
  
  
  def self.scrape_results
    # Transfermarkt::PlayerScraper.new("https://www.transfermarkt.us/schnellsuche/ergebnis/schnellsuche?query=#{playername}&x=0&y=0")
    
    players = []
    managers_staff = []
    teams = []
    
    players << self.scrape_players 
    managers_staff << self.scrape_managers_staff 
    teams << self.scrape_teams
    
        # go to transfermarkt search results based on input from user 
        # extract search results for players - later staff and teams 
        # instatiate a player/team/manager

    players
    managers_staff
    teams
  end
  
  def self.scrape_players
    query_search = "milan"
    doc = Nokogiri::HTML(open("https://www.transfermarkt.us/schnellsuche/ergebnis/schnellsuche?query=#{query_search}&x=0&y=0"))
    binding.pry
    title = doc.search("div.table-header").first.text 
  end 
  
  def self.scrape_managers_staff
  end
  
  def self.scrape_teams
  end
  
end 