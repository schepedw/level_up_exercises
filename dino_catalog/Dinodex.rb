require './dinosaur'
require './parser'
require 'pry'
#Parse the given csv
def parse(file)
  Parser.parse(file,nil)
end

#after parsing, create an array of Dinosaur objects
def create_dinos(dino_hash)
  dino_hash.inject([]){|dinos, dino|
      dinos<<Dinosaur.new(dino)
      dinos
  }
end

#Get user input
#TODO: Add error catching
def prompt_mode(dinos)
    puts "Welcome to the Dinodex\n"
    puts ( search_criteria =  "You may search using one or more of the following criteria and syntax.\n" +
     "Walking:(Biped|Quadriped) Size:(Big|Small) Diet:(Carnivore|Piscivore|Insectivore|Herbivore)\n" +
      "Name:(Specific Name) Period:(Jurassic|Albian|Cretaceous|Triassic)\n" +
      "Continent:(North America|Europe|Africa|Asia|South America)\n" +
      "Please separate search criteria by a comma\n" +
      "Enter \"Exit\" to leave\n\n")
    loop do 
      exit if (input=gets.chomp.downcase) == "exit"
      begin 
        criteria=parse_input(input)
        find_matches(criteria, dinos).each do |match|
          puts match.to_s + "\n"
        end
      rescue NoMethodError
        puts "---------Error: Invalid Search Criteria or Syntax-------------"
      end
      puts "\n" + search_criteria
    end
end

#Parse out the search criteria given by the user
def parse_input(input)
  input.split(',').inject({}){|criteria,criterion| 
    key_value_array = criterion.split(':')
    criterion_key = key_value_array[0].strip
    criterion_value = key_value_array[1].strip
    criteria[criterion_key] = criterion_value#Could just use the hash method on key_value_array, but you lose strip.
    criteria
  }
end

#Find the dinos that match the given criteria
def find_matches(criteria, dinos)
  dinos.select{|dino|dino.matches_criteria(criteria)}
end

def main
  dino_hash= Parser.parse_african_dinos(open("./african_dinoaur_export.csv"))
              .concat(Parser.parse_dinodex(open("./dinodex.csv")))
  dinos=create_dinos(dino_hash)
  prompt_mode(dinos)
end
main()

