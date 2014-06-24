require 'spec_helper'

describe Json_Parser do

  it "should throw error for non-existant file" do
    expect{ Json_Parser.new("not_here.json") }.to raise_error(Errno::ENOENT)
  end

  it "should only accept json files" do
    expect{ Json_Parser.new("README.md") }.to raise_error(JSON::ParserError)
  end

  let(:parser) { Json_Parser.new("source_data.json") }
  let(:parsed_data) { parser.cohorts }
  subject{ parsed_data }

  it "should not be nil" do
    expect(parsed_data).to_not be_nil
  end

  it "should be in the form {{a => {successes => 10, trials => 0}}, b=> {...} }" do
    expect(parsed_data).to have_key("A")
    a = parsed_data["A"]
    expect(a).to have_key("trials")
    expect(a).to have_key("successes")
  end

  it "should have a nonzero number of trials and successes for each cohort" do
    parsed_data.each_value do |tests|
      expect(tests["successes"]).to be > 0
      expect(tests["trials"]).to be > 0
    end
  end

end
