require './split_test.rb'
require 'spec_helper'
require 'rspec/its'
require 'rspec/expectations'

describe Split_Test do
  let(:split_test){Split_Test.new("source_data.json")}
  subject{split_test}
  it {should respond_to(:get_conversion_rate)}
  it {should respond_to(:get_SSE)}
  it {should respond_to(:get_conversion_rate_range)}
  it {should respond_to(:get_chi_squared_value)}
  it {should respond_to(:get_confidence_level)}
  it "should be able to get values from parser" do
    expect(split_test.a_trials).to be > 0
    expect(split_test.b_trials).to be > 0
    expect(split_test.a_successes).to be_truthy
    expect(split_test.b_successes).to be_truthy
  end

  it "should be able to correctly calculate conversion rate" do
    test1 = split_test.get_conversion_rate(1000, 500)
    test2 = split_test.get_conversion_rate(1000, 1000)
    expect (test1).should be_within(0.001).of(0.5)
    expect (test2).should be_within(0.001).of(1.0)
  end

  it "should be able to correctly calculate SSE" do
    test1 = split_test.get_SSE(1, 2) 
    test2 = split_test.get_SSE(0.5,3)
    expect (test1).should be_within(0.001).of(0.0)
    expect (test2).should be_within(0.001).of(0.289)
  end

  it "should be able to give conversion rate range" do 
    test1 = split_test.get_conversion_rate_range(1000, 40)
    range_min = test1.min
    range_max = test1.max
    expect (range_min).should be_within(0.001).of(0.0278)
    expect (range_max).should be_within(0.001).of(0.0521)
  end

  it "should be able to calculate chi_square statistic" do
    chi_square = split_test.get_chi_squared_value(23, 1507, 33, 1312)
    expect chi_square.should be_within(0.001).of(3.384)
  end

  it "should be able calculate confidence level" do
    confidence_50 = split_test.get_confidence_level(0.456)
    confidence_90 = split_test.get_confidence_level(2.707)
    confidence_95 = split_test.get_confidence_level(3.842)
    confidence_98 = split_test.get_confidence_level(5.413)
    confidence_99 = split_test.get_confidence_level(6.636)
    confidence_999 = split_test.get_confidence_level(10.828)
    expect confidence_50.should equal(0.5)
    expect confidence_90.should equal(0.90)
    expect confidence_95.should equal(0.95)
    expect confidence_98.should equal(0.98)
    expect confidence_99.should equal(0.99)
    expect confidence_999.should equal(0.999)
  end
  

end
