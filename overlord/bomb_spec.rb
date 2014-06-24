require 'spec_helper'

describe Bomb do

  it "should only allow numeric activation/deactivation codes" do
    expect { Bomb.new("abcd", 1234).to raise_error(ArgumentError) }
    expect { Bomb.new(1234, "abcd").to raise_error(ArgumentError) }
  end
  # Starts out in inactive state
  # Gathers activation/deactivation code from commandline
  #   Only takes numerical input for codes
  # Uses defaults if no codes given
  # Has a timer that starts at 30 seconds
  # Timer ticks when bomb is active
  # Timer stops when bomb is inactive
  # Bomb records unsuccessful deactivation attempts
  #   Blows up on 3rd successive failure



end
