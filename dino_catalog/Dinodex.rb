require './Dinosaur'
require 'csv'

#Parse the given csv
def parse(file)
  CSV::Converters[:blank_to_nil] = lambda do |field|
    field && field.empty? ? nil : field
  end
  CSV::HeaderConverters[:pick_header_title]= lambda do |header|
    if header=="genus"
      return "name"
    elsif header=="weight_in_lbs"
      return "weight"
    elsif header=="carnivore"
      return "diet"
    else
      return header
    end
  end
  csv=CSV.new(file, :headers=>true, :header_converters=>[:downcase,:pick_header_title], :converters=>[:integer,:blank_to_nil])
  csv=Array(csv)
  csv.map!{|row|
    row.to_hash
  }

  csv
end

#after parsing, create an array of Dinosaur objects
def createDinos(arrayHash)
  dinoArr=Array.new;
  arrayHash.each do |dino|
    rex=Dinosaur.new(dino["name"],dino["period"],dino["walking"],dino["weight"],dino["diet"],dino["description"], dino["continent"])
    dinoArr<<rex
  end
  dinoArr
end

#Get user input. 
def promptMode(dinos)
  input=""
  while input.downcase != "exit"
    puts "Welcome to the Dinodex\n"+
      "You may search using one or more of the following criteria and syntax.\n"+
      "Walking:(Biped|Quadriped) Size:(Big|Small) Diet:(Carnivore|Piscivore|Insectivore)\n"+
      "Name:(Specific Name) Period:(Jurassic|Albian|Cretaceous|Triassic)\n"+
      "Continent:(North America|Europe|Africa|Asia|South America)\n"+
      "Please separate search criteria by a comma\n"+
      "Enter \"Exit\" to leave"
    input= gets.chomp
    if input.downcase != "exit"
      criteria=parseInput(input)
      findMatches(criteria, dinos)
    end
  end
end

#Parse out the search criteria given by the user
def parseInput(input)
  criteriaArray = input.split(',')
  criteria = Hash.new
  criteriaArray.each do |block|
    criterion=Hash[*(block.split(':').map!{|word|word.strip.downcase})]
    criteria.merge!(criterion)
  end
  criteria
end

#Find the dinos that match the given criteria
def findMatches(criteria, dinos)
  begin
    dinos.each do |dino|
      if dino.matchesCriteria(criteria)
       puts dino
      end
    end
  rescue NoMethodError
    puts "\n----ERROR: Invalid Search Criteria-----\n"
  end
end

def main
  dinoHash= parse(open("./african_dinoaur_export.csv")).concat(parse(open("./dinodex.csv")))
  dinos=createDinos(dinoHash)
  promptMode(dinos)
end
main()


