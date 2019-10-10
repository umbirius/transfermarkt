require 'pry'

class Transfermarkt::Player 
  
  attr_accessor :name, :position, :club, :age, :nationality, :market_value, :agents, :url, :header, :date_of_birth, :place_of_birth_city, :place_of_birth_country, :height, :position, :foot, :date_joined, :contract_exp, :last_contract_ext, :current_market_value, :date_current_market_value, :highest_market_value, :date_highest_market_value, :sponsor
  

  @@all = []
  
  def initialize(player_hash)
    player_hash.each {|key,value| self.send(("#{key}="), value)}
    
    @@all << self 
  end 
  
  def self.create_from_collection(player_array)
    player_array.each do |player| 
      self.new(player)
    end 
  end 
  
  def add_attributes(add_attr_hash)
    add_attr_hash.each do |key, value| 
      self.send(("#{key}="), value)
    end 
  end 
  
  def self.all 
    @@all 
  end 
  
  def self.reset 
    @@all = []
  end 
  
end 

