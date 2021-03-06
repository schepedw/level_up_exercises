require 'AASM'
require 'active_record'
require 'sinatra/activerecord'
require 'pry'
class Bomb < ActiveRecord::Base

  def self.ACTIVE_STATES 
    ["active", "one_wrong_guess", "two_wrong_guesses"]
  end

  validates_presence_of :activation_code, :deactivation_code, :status
  def initialize(codes_hash = {})
    codes_hash ||= {}
    activation_code = codes_hash[:activation_code] || "1234"
    deactivation_code = codes_hash[:deactivation_code] || "0000"
    validate_input_code(activation_code)
    validate_input_code(deactivation_code)
    super()
    write_attributes(activation_code, deactivation_code)
  end

  def state
    self[:status]
  end

  def write_attributes(activation_code,deactivation_code)
    write_attribute(:activation_code, activation_code)
    write_attribute(:deactivation_code, deactivation_code)
    write_attribute(:status, "inactive")
  end


  def input_code(code)
    if (code == activation_code and inactive?) or
      (code == deactivation_code and Bomb.ACTIVE_STATES.include?(status))
        accept_code()
    elsif exploded?
      return
    else
      incorrect_code()
    end
  end

  def validate_input_code(input_code)
    raise ArgumentError, "#{input_code} is not 4 digits" unless !!(input_code =~ /^[0-9]{4}$/)
  end

  include AASM
  aasm :column => :status do
    state :inactive, :initial => true
    state :active
    state :one_wrong_guess
    state :two_wrong_guesses
    state :exploded

    event :accept_code do
      transitions :from => :inactive, :to => :active
      transitions :from => [:active, :one_wrong_guess, :two_wrong_guesses], :to => :inactive
    end

    event :incorrect_code do
      transitions :from => :active, :to => :one_wrong_guess
      transitions :from => :one_wrong_guess, :to => :two_wrong_guesses
      transitions :from => :two_wrong_guesses, :to => :exploded
      transitions :from => :inactive, :to => :inactive
    end

    event :explode do
      transitions :from => [:active, :inactive, :one_wrong_guess, :two_wrong_guesses], :to => :exploded

    end

  end
  protected :accept_code, :incorrect_code, :explode#, :activation_code, :activation_code=#, :deactivation_code# :deactivation_code=
  protected
  def status=(val)
    self[:status] = val
  end

  def activation_code
    self[:activation_code]
  end
  def activation_code=(val)
    self[:activation_code]=val
  end
  def deactivation_code
    self[:deactivation_code]
  end
  def deactivation_code=(val)
    self[:deactivation_code]=val
  end
end
