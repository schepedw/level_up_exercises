require './Dinosaur'
require 'csv'
require 'pry'
#Parse the given csv
def parse(file)
  CSV::Converters[:blank_to_nil] = ->(field) {field && field.empty? ? nil : field}
  CSV::HeaderConverters[:pick_header_title]= lambda do |header| #Can this be put somewhere else and passed in? Is that really any better?
    returnVal=header
    returnVal = header=="genus" ? "name" : returnVal
    returnVal = header=="weight_in_lbs" ? "weight" : returnVal
    returnVal = header=="carnivore" ? "diet" : returnVal
    returnVal
  end
  csv=CSV.new(file, :headers=>true, :header_converters=>[:downcase,:pick_header_title], :converters=>[:integer,:blank_to_nil])
  csv=Array(csv)
  csv.map!{|row| row.to_hash }
  csv


end

#after parsing, create an array of Dinosaur objects
def create_dinos(array_hash)
  dino_arr=Array.new;
  array_hash.each do |dino|
    rex=Dinosaur.new(dino["name"],dino["period"],dino["walking"],dino["weight"],dino["diet"],dino["description"], dino["continent"])
    dino_arr<<rex
  end
  dino_arr
end

#Get user input
def prompt_mode(dinos)
    puts "Welcome to the Dinodex\n"+
      "You may search using one or more of the following criteria and syntax.\n"+
      "Walking:(Biped|Quadriped) Size:(Big|Small) Diet:(Carnivore|Piscivore|Insectivore)\n"+
      "Name:(Specific Name) Period:(Jurassic|Albian|Cretaceous|Triassic)\n"+
      "Continent:(North America|Europe|Africa|Asia|South America)\n"+
      "Please separate search criteria by a comma\n"+
      "Enter \"Exit\" to leave"
    while (input=gets.chomp.downcase) != "exit"
      criteria=parse_input(input)
      find_matches(criteria, dinos)
    end
end

#Parse out the search criteria given by the user
def parse_input(input)
  criteria_array = input.split(',')
  criteria = Hash.new
  criteria_array.each do |block|
    criterion=Hash[*(block.split(':').map!{|word|word.strip.downcase})]
    criteria.merge!(criterion)
  end
  criteria
end

#Find the dinos that match the given criteria
def find_matches(criteria, dinos)
  begin
    dinos.each do |dino|
      if dino.matches_criteria(criteria)
       puts dino
      end
    end
  rescue NoMethodError
    puts "\n----ERROR: Invalid Search Criteria-----\n"
  end
end

def main
  dino_hash= parse(open("./african_dinoaur_export.csv")).concat(parse(open("./dinodex.csv")))
  dinos=create_dinos(dino_hash)
  prompt_mode(dinos)
end
main()


