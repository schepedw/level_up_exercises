require 'spec_helper'

describe Bomb do

  ActiveRecord::Base.establish_connection(
    :adapter => 'postgresql',
  )
  set :database, :development

  it "should only allow numeric activation/deactivation codes" do
    expect{ Bomb.new(:activation_code => "abcd", :deactivation_code => "1234")}.to raise_error(ArgumentError)
    expect{ Bomb.new(:activation_code => "1234", :deactivation_code => "abcd")}.to raise_error(ArgumentError)
  end

  it "should only allow codes of 4 digits" do 
    expect{ Bomb.new(:activation_code => "123", :deactivation_code => "1234")}.to raise_error(ArgumentError)
    expect{ Bomb.new(:activation_code => "1234", :deactivation_code => "12345")}.to raise_error(ArgumentError)
  end

  it "should only allow status change through the input_code method" do
    expect{ Bomb.new.status="1234"}.to raise_error(NoMethodError)
  end

  context 'inactive bomb' do
    let(:bomb) { mock_model('Bomb')}
    it "should start in inactive status" do
      expect(bomb.status).to eql("inactive")
    end
    it "should be able to be activated" do
      expect{activate_bomb(bomb)}.to change(bomb, :status).from("inactive").to("active") 
    end
  # Timer stops when bomb is inactive
  end

  context 'active bomb' do
    let(:bomb) { Bomb.new }
    it "should record failed attempts to deactive, and explode after the third attempt" do
      expect{activate_bomb(bomb)}.to change(bomb, :status).from("inactive").to("active") 
      expect{try_wrong_code(bomb)}.to change(bomb, :status).from("active").to("one_wrong_guess") 
      expect{try_wrong_code(bomb)}.to change(bomb, :status).from("one_wrong_guess").to("two_wrong_guesses") 
      expect{try_wrong_code(bomb)}.to change(bomb, :status).from("two_wrong_guesses").to("exploded") 
    end

    it "should be deactivatable from any status except exploded" do 
      activate_bomb(bomb)
      expect{deactivate_bomb(bomb)}.to change(bomb, :status).from("active").to("inactive")
      activate_bomb(bomb)
      expect{try_wrong_code(bomb)}.to change(bomb, :status).from("active").to("one_wrong_guess")
      expect{deactivate_bomb(bomb)}.to change(bomb, :status).from("one_wrong_guess").to("inactive")
      activate_bomb(bomb)
      expect{2.times {try_wrong_code(bomb)}}.to change(bomb, :status).from("active").to("two_wrong_guesses")
      expect{deactivate_bomb(bomb)}.to change(bomb, :status).from("two_wrong_guesses").to("inactive")
      activate_bomb(bomb)
      expect{3.times {try_wrong_code(bomb)}}.to change(bomb, :status). from("active").to("exploded")
      expect{deactivate_bomb(bomb)}.not_to change(bomb, :status)
      expect{activate_bomb(bomb)}.not_to change(bomb, :status)
    end
      #test the change here
  # Timer ticks when bomb is active
  end

  # Starts out in inactive status
  # Has a timer that starts at 30 seconds
  # Bomb records unsuccessful deactivation attempts
  #   Blows up on 3rd successive failure
  def activate_bomb(bomb)
    bomb.input_code("1234")
  end

  def deactivate_bomb(bomb)
    bomb.input_code("0000")
  end
  def try_wrong_code(bomb)
    bomb.input_code("4249082123049")
  end

end
