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

  def big()
    @weight>4000
  end

  def small()
    @weight>0&&weight<4000
  end

  def matchesCriteria(criteria)
    criteria.each do |key, value|
      if key =="period"
         if !self.send(key).downcase.include?(value)
           return false
         end
      elsif key=="size"
        if !self.send(value)
          return false
        end
      elsif self.send(key).downcase!=value
        return false
      end
    end
    true
  end

  def to_s
    returnVal="Name: #{@name}\tPeriod: #{@period}\tWalking: #{@walking}\tContinent: #{@continent} "
    if @weight>0
      returnVal+="\tWeight: #{@weight} "
    end
    if @diet!=""
      returnVal+="\tDiet: #{@diet} "
    end
    if @description!=""
      returnVal+="\tDescription: #{@description}"
    end
    returnVal
  end
end
