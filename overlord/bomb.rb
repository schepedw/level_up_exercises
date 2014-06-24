require 'state_machine'

class Bomb 
  attr_reader :status
  
  def initialize(activation_code, deactivation_code)
    @status = "inactive"
    activation_code ||= "1234"
    deactivation_code ||= "0000"
    check_input_validity(activation_code)
    check_input_validity(deactivation_code)
    @activation_code = activation_code
    @deactivation_code = deactivation_code
    @fail_attempts = 0
  end

 # def accept_code(input_code)
 #   check_activation_code(input_code) if status == "inactive"
 #   check_deactivation_code(input_code) if status == "active"
 # end


#  private

  state_machine :status, :initial => :inactive do
    event :switch do
      transition :active => :inactive
      transition :inactive => :active
    end

    #event :deactivate do
    #  transition :active => :inactive
    #end

    event :explode do
      transition :active =>:exploded
    end
  end




  def check_input_validity(input_code)
    raise ArgumentError, "Input code must be 4 digits" unless input_code =~ /[[:digit:]]{4}/
  end

#  def check_activation_code(input_code)
 #   @status = "active" if input_code == @activation_code
#  end

#  def deactivation_code(input_code)
#    if input_code == @deactivation_code
#      @status = "inactive"
#      @fail_attempts = 0
 #   else
#      @fail_attempts += 1
#      blow_up if @fail_attempts == 3
#    end
end
