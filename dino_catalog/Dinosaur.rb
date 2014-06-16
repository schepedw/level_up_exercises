#Representation of a dinosaur
class Dinosaur
  LARGE_WEIGHT_CUTOFF = 4000
  attr_reader :name, :period, :diet, :weight, :walking, :diet, :description, :continent
  def initialize(attributes)
    @diet=attributes["diet"]
    @name=attributes["name"]
    @period=attributes["period"]
    @weight=attributes["weight"] ||= -1
    @walking=attributes["walking"]
    @description=attributes["description"] ||= ""
    @continent=attributes["continent"]
  end

  def big?
    @weight>LARGE_WEIGHT_CUTOFF
  end
  alias_method :big, :big?


  def small?
    @weight.between?(0,LARGE_WEIGHT_CUTOFF)
  end
  alias_method :small, :small?

  def matches_criteria(criteria)
    criteria.each do |key, value|
      case key
      when "period"
        return false unless send(key).downcase.include?(value)
      when "size"
       return false unless send(value)
      else
        return false unless send(key).downcase == value
      end
    end
    true
  end

  def to_s
    return_val="Name: %-21s Period: %-20s Walking: %-13s Continent: %-15s "% [@name, @period,@walking,@continent]
    return_val+="Weight (lbs): %-7d"% [@weight] if @weight>0
    return_val+="Diet: %-15s " % [@diet] if @diet!=""
    return_val+="Description: #{@description}" if @description!=""
    return_val
  end
end
