require 'pry'

class Transfermarkt::Player 
  
  attr_accessor :name, :position, :club, :age, :nationality, :market_value, :agents, :url 

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
  
  def self.all 
    @@all 
  end 
  
end 

