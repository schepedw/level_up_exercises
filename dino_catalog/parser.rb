require 'csv'
class Parser
  
  def initialize
    CSV::Converters[:blank_to_nil] = -> (field) {field && field.empty? ? nil : field}
    CSV::HeaderConverters[:pick_header_title] = method(:pick_header_title)
  end

  def pick_header_title(header)
    case header
      when "genus" then "name"
      when "weight_in_lbs" then "weight"
      when "carnivore" then "diet"
      else header
    end
  end

  def parse_african_dinos(file)
    dinos = parse_dinodex(file)
    dinos.each do |row| 
      row["continent"] = "Africa"
      row["diet"] = row["diet"] == "Yes" ? "Carnivore":"Herbivore"
     end
  end

  def parse_dinodex(file)
    csv = CSV.new(file, headers: true, header_converters: [:downcase, :pick_header_title], converters: [:integer, :blank_to_nil])
    csv.to_a.map(&:to_hash)
  end
end
