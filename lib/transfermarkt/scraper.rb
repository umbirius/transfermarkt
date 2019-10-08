

class Transfermarkt::Scraper 
 
 attr_accessor :doc, :url, :new_url

  
  def self.set_doc(query)
    @url = "https://www.transfermarkt.us/schnellsuche/ergebnis/schnellsuche?query=#{query}&x=0&y=0"
    @doc = Nokogiri::HTML(open(@url))
  end 
  
  def self.next_url
    next_btn = @doc.css("div.row div.box div.responsive-table div.pager li.naechste-seite a")
      if next_btn.attribute("href")
       "https://www.transfermarkt.com" + next_btn.attribute("href").value
      else 
        nil
      end 
  end 
  
  def self.player_profile_url(player)
    player_url = player.url
    player_doc = Nokogiri::HTML(open(player_url))
    header = doc.css("div.row div.dataMain div.dataName").text #could split into [num, first, last]
    date_of_birth = doc.css("div.large-8 div.box div.row div.spielerdaten table.auflistung tr td a").first.text
    
  end 
  
  
  def self.scrape_next_page 
    @url = self.next_url
    @doc = Nokogiri::HTML(open(@url))
    next_page_players = self.scrape_players
    next_page_players
  end 
    
  
  def self.scrape_players
    binding.pry
    players = []
    # loop do
      player_array = @doc.css("div.box").first #first box with player results
      player_array.css("table.items > tbody > tr").each do |player| #add the evens or find a way to add both
      
      
          players << {
            :name => player.css("td.hauptlink a").text, 
            :position => player.css("td.zentriert").first.text,
            :club => player.css("a.vereinprofil_tooltip").text,
            :age => player.css("td.zentriert")[2].text,
            :nationality => player.css("td.zentriert img")[1].attribute("title").value,
            :market_value => player.css("td.rechts").first.text,
            :agents => player.css("td.rechts a").text,
            :url => "https://www.transfermarkt.com" + player.css("td.hauptlink a").attribute("href").value
          }
          
      # @new_url = self.next_url
      
        # if @new_url
        #   @doc = Nokogiri::HTML(open(@new_url))
        # else 
        #   break
        # end 
      end 
      
    # end 
    binding.pry
    players
  end 
  
  def self.scrape_managers_staff
  end
  
  def self.scrape_teams
  end
  
end