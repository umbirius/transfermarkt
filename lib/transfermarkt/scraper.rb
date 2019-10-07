
class Transfermarkt::Scraper 
 
 attr_accessor :doc, :url

  
  def self.set_doc(query)
    @url = "https://www.transfermarkt.us/schnellsuche/ergebnis/schnellsuche?query=#{query}&x=0&y=0"
    @doc = Nokogiri::HTML(open(@url))
  end 
  
  def self.next_url
    next_btn = @doc.css("div.row div.box div.responsive-table div.pager li.naechste-seite a").attribute("href").value
  end 

    
  
  def self.scrape_players(url)
    players = []
    player_array = @doc.css("div.box").first #first box with player results
    player_array.css("table.items tbody tr.odd").each_with_index do |player, i| #add the evens or find a way to add both
    
        players[i] = {
          :name => player.css("td.hauptlink a").text, 
          :position => player.css("td.zentriert").first.text,
          :club => player.css("a.vereinprofil_tooltip").text,
          :age => player.css("td.zentriert")[2].text,
          :nationality => player.css("td.zentriert img")[1].attribute("title").value,
          :market_value => player.css("td.rechts").first.text,
          :agents => player.css("td.rechts a").text
        }
    
    end 
    players
  end 
  
  def self.scrape_managers_staff
  end
  
  def self.scrape_teams
  end
  
end