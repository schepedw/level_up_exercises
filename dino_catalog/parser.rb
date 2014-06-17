require 'csv'
class Parser
  CSV::Converters[:blank_to_nil] =-> (field) {field && field.empty? ? nil : field}
  CSV::HeaderConverters[:pick_header_title]= lambda do |header|
    returnVal = header
    returnVal = header == "genus" ? "name" : returnVal
    returnVal = header == "weight_in_lbs" ? "weight" : returnVal
    returnVal = header == "carnivore" ? "diet" : returnVal
    returnVal
  end
  def self.parse_african_dinos(file)
    dinos=self.parse_dinodex(file)
    dinos.each do |row| 
      row["continent"]="Africa"
      row["diet"]= row["diet"]=="Yes"? "Carnivore":"Herbivore"
     end
  end

  def self.parse_dinodex(file)
    csv=CSV.new(file, headers: true, header_converters: [:downcase, :pick_header_title], converters: [:integer, :blank_to_nil])
    csv.to_a.map(&:to_hash)
  end
end
