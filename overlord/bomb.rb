require 'AASM'
require 'active_record'
require 'sinatra/activerecord'
require 'pry'
class Bomb < ActiveRecord::Base
#  has_one :activation_code
 # has_one :status
 # has_one :deactivation_code
  validates_presence_of :activation_code, :deactivation_code, :status
  after_initialize :init
  
  def init
    self.activation_code ||= "1234"
    self.deactivation_code ||= "0000"
    self.status = :inactive
    validate_input_code(self.activation_code)
    validate_input_code(self.activation_code)
  end
  ACTIVE_STATES = ["active", "one_wrong_guess", "two_wrong_guesses"]


  include AASM
  aasm :column => :status do
    state :inactive
    state :active
    state :one_wrong_guess
    state :two_wrong_guesses
    state :exploded
    event :accept_code do
      transitions :from => :inactive, :to => [:active]
      transitions :from => [:active, :one_wrong_guess, :two_wrong_guesses], :to => :inactive
    end

    event :incorrect_code do
      transitions :from => :active, :to => :one_wrong_guess
      transitions :from => :one_wrong_guess, :to => :two_wrong_guesses
      transitions :from => :two_wrong_guesses, :to => :exploded
    end

    event :explode do
      transitions :from => [:active, :inactive, :one_wrong_guess, :two_wrong_guesses], :to => :exploded

    end

    def accept_code(code)
      if (code == self.activation_code and self.status == :inactive) or
        (code == self.deactivation_code and ACTIVE_STATES.include?(self.activation_code))
          puts "CALLING SUPER WITH code =#{code}"
          super()
      else
        puts "incorrect code!"
        incorrect_code()
      end
    end

  end

  private :incorrect_code, :explode

  def validate_input_code(input_code)
    raise ArgumentError, "#{input_code} is not 4 digits" unless !!(input_code =~ /^[0-9]{4}$/)
  end

end
