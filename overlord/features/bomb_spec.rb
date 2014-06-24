require 'spec_helper'

describe Bomb do

  it "should only allow numeric activation/deactivation codes" do
    expect { Bomb.new("abcd", 1234).to raise_error(ArgumentError) }
    expect { Bomb.new(1234, "abcd").to raise_error(ArgumentError) }
  end

  it "should only allow 4 digit codes" do
    expect { Bomb.new(12345, 1234).to raise_error(ArgumentError) }
    expect { Bomb.new(1234, 12345).to raise_error(ArgumentError) }
  end

  it "should have valid activation/deactivation defaults" do
    expect { Bomb.new(nil, nil).to_not raise_error }
  end




  context "active" do
    let(:bomb) { Bomb.new(nil,nil).accept_code("1234") }
    it "should change states after being deactivated" do
      expect{bomb.accept_code(0000)}.to change(bomb.status).from("active").to("inactive")
    end

  end

  context "inactive" do
    let(:bomb) { Bomb.new(nil, nil) }

    it "should change states after being activated" do
      expect{bomb.accept_code(1234)}.to change(bomb.status).from("inactive").to("active")
    end

  end
  # Uses defaults if no codes given
  # Has a timer that starts at 30 seconds
  # Timer ticks when bomb is active
  # Timer stops when bomb is inactive
  # Bomb records unsuccessful deactivation attempts
  #   Blows up on 3rd successive failure



end
