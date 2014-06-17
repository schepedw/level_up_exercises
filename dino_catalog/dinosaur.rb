#Representation of a dinosaur

class InvalidSearchCriteriaError < RuntimeError; end

class Dinosaur

  LARGE_WEIGHT_CUTOFF = 4000

  attr_reader :name, :period, :diet, :weight, :walking, :diet, :description, :continent, :size

  def initialize(attributes)
    @diet = attributes["diet"]
    @name = attributes["name"]
    @period = attributes["period"]
    @weight = attributes["weight"] ||= -1
    @walking = attributes["walking"]
    @description = attributes["description"] ||= ""
    @continent = attributes["continent"]
  end

  def big?
    @weight > LARGE_WEIGHT_CUTOFF
  end
  alias_method :big, :big?

  def small?
    @weight.between?(0,LARGE_WEIGHT_CUTOFF)
  end
  alias_method :small, :small?

  def matches_criteria(criteria)
    criteria.all?{|criterion, value| matches_criterion(criterion, value)}
  end

  def matches_criterion(criterion, value)
    raise InvalidSearchCriteriaError, "#{criterion} is not a valid search criterion" unless is_valid_criterion?(criterion)
    case criterion 
      when "period" then send(criterion).downcase.include?(value)
      when "weight" then send(value)
      else send(criterion).downcase == value
    end
  end

  def to_s
    return_val = "Name: %-21s Period: %-20s Walking: %-13s Continent: %-15s " % [@name, @period, @walking, @continent]
    return_val += "Weight (lbs): %-7d"% [@weight] if @weight > 0
    return_val += "Diet: %-15s " % [@diet] if @diet != ""
    return_val += "Description: #{@description}" if @description != ""
    return_val
  end
  
  private
  def is_valid_criterion?(criterion)
    instance_variables.include?("@#{criterion}".to_sym)
  end

end

