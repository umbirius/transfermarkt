

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
  
  def self.player_profile(player)
    player_url = player.url
    player_doc = Nokogiri::HTML(open(player_url))
    
    hash = {
      :header => player_doc.css("div.row div.dataMain div.dataName").text.gsub(/\n/,"").strip,
      :date_of_birth => player_doc.css("div.large-8 div.box div.row div.spielerdaten table.auflistung tr td a").first.text,
      :place_of_birth_city => player_doc.css("div.large-8 div.box div.row div.spielerdaten table.auflistung tr td span").text.strip.gsub(/[^a-zA-Z]/,""),
      :place_of_birth_country => player_doc.css("div.large-8 div.box div.row div.spielerdaten table.auflistung tr td span img").attribute("title").value,
      :height => player_doc.css("div.large-8 div.box div.row div.spielerdaten table.auflistung tr td")[4].text.strip,
      :position => player_doc.css("div.large-8 div.box div.row div.spielerdaten table.auflistung tr td")[6].text.strip,
      :foot => player_doc.css("div.large-8 div.box div.row div.spielerdaten table.auflistung tr td")[7].text.strip,
      :date_joined => player_doc.css("div.large-8 div.box div.row div.spielerdaten table.auflistung tr td")[10].text.strip,
      :contract_exp => player_doc.css("div.large-8 div.box div.row div.spielerdaten table.auflistung tr td")[11].text.strip,
      :last_contract_ext => player_doc.css("div.large-8 div.box div.row div.spielerdaten table.auflistung tr td")[12].text.strip,
      :current_market_value => player_doc.css("div.large-8 div.box div.row div.large-6 div.marktwertentwicklung  div > div.zeile-oben > div.right-td").text.strip,
      :date_current_market_value => player_doc.css("div.large-8 div.box div.row div.large-6 div.marktwertentwicklung  div > div.zeile-mitte > div.right-td").text.strip,
      :highest_market_value => player_doc.css("div.large-8 div.box div.row div.large-6 div.marktwertentwicklung  div > div.zeile-unten > div.right-td").text.strip.squeeze("  ").split(" \n ")[0],
      :date_highest_market_value => player_doc.css("div.large-8 div.box div.row div.large-6 div.marktwertentwicklung  div > div.zeile-unten > div.right-td").text.strip.squeeze("  ").split(" \n ")[1]
    }
  
    if player_doc.css("div.large-8 div.box div.row div.spielerdaten table.auflistung tr td")[13]
      hash[:sponsor] = player_doc.css("div.large-8 div.box div.row div.spielerdaten table.auflistung tr td")[13].text.strip
    else
      hash[:sponsor] = "none"
    end 
    hash

  end 
  
  
  def self.scrape_next_page 
    @url = self.next_url
    @doc = Nokogiri::HTML(open(@url))
    next_page_players = self.scrape_players
    next_page_players
  end 
    
  
  def self.scrape_players
    players = []
    
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
          
      end 
      
    players
  end 
  
  def self.scrape_managers_staff
  end
  
  def self.scrape_teams
  end
  
end