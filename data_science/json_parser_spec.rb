require 'spec_helper'
require './json_parser.rb'
require 'rspec/its'

describe JSON_Parser do 
  
  it "Should throw error for non-existant file" do
    expect{JSON_Parser.new("not_here.json")}.to raise_error(Errno::ENOENT)
  end

  it "Should only accept json files" do
    expect{JSON_Parser.new("README.md")}.to raise_error(JSON::ParserError)
  end

  parser = JSON_Parser.new("source_data.json")
  let!(:data_hash){parser.parsed_file}
  let!(:a_successes){parser.a_successes}
  let!(:a_failures){parser.a_failures}
  let!(:b_successes){parser.b_successes}
  let!(:b_failures){parser.b_failures}
  
  subject{data_hash}
  it {should_not be_nil}
  it "Should have more than one entry" do
    data_hash.count.should > 1
  end

  it "Should be able to gather cohorts and results" do
    a_successes.should_not be_nil
    a_failures.should_not be_nil
    b_successes.should_not be_nil
    b_failures.should_not be_nil
  end

  it "Should not lose results in counting cohorts and results" do
    sum = a_successes + a_failures + b_successes + b_failures
    data_hash.count.should == sum
  end

end
