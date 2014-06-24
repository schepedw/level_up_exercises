require 'spec_helper'

describe Split_Test do

  it "should allow successes | successes <= trials" do
    expect { Split_Test.new(10, 11).to raise_error(ArgumentError) }
  end

  it "should only allow integer trials/successes" do
    expect { Split_Test.new(3, 2.5).to raise_error(ArgumentError) }
    expect { Split_Test.new(3.5, 3).to raise_error(ArgumentError) }
    expect { Split_Test.new(3.5, 3.3).to raise_error(ArgumentError) }
  end

  let(:split_test) { Split_Test.new(10, 5) }
  let(:split_test2) { Split_Test.new(100,5) }
  let(:border_alpha_values) { [0, 0.455, 2.706, 3.841, 5.412, 6.635, 10.827] }
  let(:corresponding_p_values) { [0, 0.5, 0.1, 0.05, 0.02, 0.01, 0.001] }
  subject{ split_test }

  it "should only allow objects that have successes and failures for confidence level comparison" do
    expect{ split_test.confidence_level_with(3).to raise_error(NoMethodError) }
  end

  it "should be able to save input values" do
    expect split_test.trials == 10
    expect split_test.successes == 5
    expect split_test.failures == 5
  end

  it "should be able to correctly calculate conversion rate" do
    test1 = split_test.conversion_rate
    expect(test1).to be_within(0.001).of(0.5)
  end

  it "should be able to correctly calculate sse" do
    test1 = split_test.standard_squared_error
    expect(test1).to be_within(0.001).of(0.158)
  end

  it "should be able to give conversion rate range" do 
    test1 = split_test.conversion_range
    range_min = test1.min
    range_max = test1.max
    expect(range_min).to be_within(0.001).of(0.190)
    expect(range_max).to be_within(0.001).of(0.809)
  end

  it "should be able to get p_values" do
    border_alpha_values.each_with_index do |alpha, index|
      observed_p_val =  Split_Test::P_VALUES.detect{|range, _| range.include? alpha}
      expect(corresponding_p_values[index]).to eq(observed_p_val[1])
    end
  end

  it "should be able calculate confidence level" do
    confidence_level = split_test.confidence_level_with(split_test2)
    expect(confidence_level).to eq(0.999)
  end

end
