require './dinosaur'
require './parser'
require 'pry'
class Dinodex

  attr_reader :dinos
  
  def initialize
    parser = Parser.new
    dino_hash = parser.parse_african_dinos(open("./african_dinoaur_export.csv"))
                      .concat(parser.parse_dinodex(open("./dinodex.csv")))
    @dinos=create_dinos(dino_hash)
  end


  #Get user input
  def prompt_mode
      puts "Welcome to the Dinodex\n"
      print_search_criteria_help
      loop do 
        input = gets.chomp.downcase
        input.gsub!("size","weight")#The attribute of dinosaur is actually weight, though the user search is based on size
        exit if input == "exit"
        begin 
          criteria = parse_input(input)
          find_matches(criteria).each do |match|
            puts match.to_s + "\n"
          end
        rescue InvalidSearchCriteriaError => e
          puts "Error: #{e.message}"
        end
        puts "\n"
        print_search_criteria_help
      end
  end

  #Find the dinos that match the given criteria
  def find_matches(criteria)
    @dinos.select{ |dino| dino.matches_criteria(criteria)}
  end

  private

  def create_dinos(dino_hash)
    dino_hash.inject([]) do |dinos, dino|
        dinos << Dinosaur.new(dino)
    end
  end

  def print_search_criteria_help
    puts "You may search using one or more of the following criteria and syntax.\n" +
         "Walking:(Biped|Quadriped) Size:(Big|Small) Diet:(Carnivore|Piscivore|Insectivore|Herbivore)\n" +
         "Name:(Specific Name) Period:(Jurassic|Albian|Cretaceous|Triassic)\n" +
         "Continent:(North America|Europe|Africa|Asia|South America)\n" +
         "Please separate search criteria by a comma\n" +
         "Enter \"Exit\" to leave\n\n"
  end

  #Parse out the search criteria given by the user
  def parse_input(input)
    input.split(',').inject({}) do |criteria,criterion| 
      parsed_criterion = parse_criterion(criteria,criterion)
      criteria.merge(parsed_criterion)
    end
  end

  def parse_criterion(criteria,input)
      key_value_array = input.split(':').map(&:strip)
      Hash[*key_value_array] 
  end
end

def main
  dinodex = Dinodex.new
  dinodex.prompt_mode
end

main()
