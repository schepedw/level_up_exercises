#Representation of a dinosaur
class Dinosaur
  attr_reader :name, :period, :diet, :weight, :walking, :diet, :description, :continent
  def initialize(name, period, walking, weight,diet, description,continent)
    diet= diet=="Yes"? "Carnivore" : "Herbivore"
    @name=name
    @period=period
    @weight=weight||=-1
    @walking=walking
    @diet=diet||=""
    @description=description||=""
    @continent=continent||="Africa"
  end

  def big
    @weight>4000
  end

  def small
    @weight.between(0,4000)
  end

  def matches_criteria(criteria)
    criteria.each do |key, value|
      if key == "period"
         unless send(key).downcase.include?(value)
           return false
         end
      elsif key == "size"
        unless send(value)
          return false
        end
      elsif send(key).downcase != value
        return false
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
