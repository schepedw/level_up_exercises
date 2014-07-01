require 'AASM'
require 'active_record'
require 'sinatra/activerecord'
require 'pry'
class Bomb < ActiveRecord::Base

  attr_accessor :activation_code, :deactivation_code, :status

  validates_presence_of :activation_code, :deactivation_code, :status
  after_initialize :write_attributes
  def initialize(codes_hash = {})
    codes_hash ||= {}
    self.activation_code = codes_hash["activation_code"] || "1234"
    self.deactivation_code = codes_hash["deactivation_code"] || "0000"
    self.status = "inactive"
    validate_input_code(activation_code)
    validate_input_code(deactivation_code)
    super()
  end

  def write_attributes
    binding.pry
    write_attribute(:activation_code, activation_code)
    write_attribute(:deactivation_code, deactivation_code)
    write_attribute(:status, status)
  end

  ACTIVE_STATES = ["active", "one_wrong_guess", "two_wrong_guesses"]


  def input_code(code)
    if (code == self.activation_code and self.status == "inactive") or
      (code == self.deactivation_code and ACTIVE_STATES.include?(self.activation_code))
        puts "CALLING SUPER WITH code =#{code}"
        self.accept_code()
    else
      puts "incorrect code!"
      incorrect_code()
    end
  end

  def validate_input_code(input_code)
    raise ArgumentError, "#{input_code} is not 4 digits" unless !!(input_code =~ /^[0-9]{4}$/)
  end

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
      transitions :from => :inactive, :to => :inactive
    end

    event :explode do
      transitions :from => [:active, :inactive, :one_wrong_guess, :two_wrong_guesses], :to => :exploded

    end

  end
  protected :accept_code, :incorrect_code, :explode, :activation_code, :activation_code=, :deactivation_code, :deactivation_code=, :status=


end
