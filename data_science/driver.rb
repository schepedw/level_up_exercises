require './split_test.rb'
require './json_parser.rb'

def print_tests_and_successes(a_trials, a_successes, b_trials, b_successes)
  puts "A tests: #{a_trials} A successes: #{a_successes}"
  puts "B tests: #{b_trials} A successes: #{b_successes}"
end

def print_conversion_ranges(a, b)
  puts "95%% of the times, A's conversion rate is %3.2f%% +- %3.2f%%, or ranging from %3.2f%% to %3.2f%%" % 
    [a.conversion_rate * 100, a.standard_squared_error * 100, a.conversion_range.min * 100, a.conversion_range.max * 100]
  puts "95%% of the times, B's conversion rate is %3.2f%% +- %3.2f%%, or ranging from %3.2f%% to %3.2f%%" % 
    [b.conversion_rate * 100, b.standard_squared_error * 100, b.conversion_range.min * 100, b.conversion_range.max * 100]
end

def print_winner_and_confidence_level(a_conversion_rate, b_conversion_rate, confidence_level)
  if (a_conversion_rate > b_conversion_rate)
    puts "A is the winner"
  else
    puts "B is the winner"
  end
  puts "The confidence level in these findings is #{confidence_level * 100}%"
end

data_set = JSON_Parser.new("source_data.json")

before_data = Split_Test.new(data_set.get_all_a_trials, data_set.a_successes)
after_data = Split_Test.new(data_set.get_all_b_trials, data_set.b_successes)
chi_squared = after_data.calculate_chi_squared_value(before_data.successes, before_data.failures)
confidence_level = after_data.calculate_confidence_level(chi_squared)

print_tests_and_successes(before_data.trials, before_data.successes, after_data.trials, after_data.successes)
print_conversion_ranges(before_data, after_data)
print_winner_and_confidence_level(before_data.conversion_rate, after_data.conversion_rate, confidence_level)

