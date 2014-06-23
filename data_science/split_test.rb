require './json_parser.rb'
require 'pry'
class Split_Test
  CONVERT_SSE_TO_GIVE_95PERCENT_CONFIDENCE = 1.96
  attr_reader :a_trials, :b_trials, :a_successes, :b_successes

  def initialize(input_data_file)
    trial_data = JSON_Parser.new(input_data_file)
    @a_trials = trial_data.get_all_a_trials
    @b_trials = trial_data.get_all_b_trials
    @a_successes = trial_data.a_successes
    @b_successes = trial_data.b_successes
  end

  def determine_split_test_success
    a_range = get_conversion_rate_range(@a_trials, @a_successes)
    b_range = get_conversion_rate_range(@b_trials, @b_successes)
    a_failures = @a_trials - @a_successes
    b_failures = @b_trials - @b_successes
    a_conversion_rate = get_conversion_rate(@a_trials, @a_successes)
    b_conversion_rate = get_conversion_rate(@b_trials, @b_successes)
    chi_squared = get_chi_squared_value(@a_successes, a_failures, @b_successes, b_failures)
    confidence_level = get_confidence_level(chi_squared)
    print_tests_and_successes
    print_conversion_rates(a_range, b_range)
    print_winner_and_confidence_level(a_conversion_rate, b_conversion_rate, confidence_level)
    #TODO: Figure out what to do. Just printing would be nice...
  end

  def get_conversion_rate(trial_count, successes_count)
    1.0 * successes_count / trial_count
  end

  def get_SSE(conversion_rate, num_trials)
    Math.sqrt(conversion_rate * (1.0 - conversion_rate) / num_trials)
  end

  def get_conversion_rate_range(trials,successes)
    conversion_rate = get_conversion_rate(trials, successes)
    sse = get_SSE(conversion_rate, trials)
    sse *= CONVERT_SSE_TO_GIVE_95PERCENT_CONFIDENCE
    low = conversion_rate - sse
    high = conversion_rate + sse
    low .. high
  end

  def get_chi_squared_value(a_successes, a_failures, b_successes, b_failures)
    total = a_successes + a_failures + b_successes + b_failures
    1.0 * total * (a_successes * b_failures - b_successes * a_failures) ** 2 /
      ((a_successes + a_failures) * (a_successes + b_successes) * (b_successes + b_failures) *
        (a_failures + b_failures))
  end

  def get_confidence_level(chi_square_value) 
    alpha = 
      case
        when chi_square_value.between?(0, 0.454) then 0
        when chi_square_value.between?(0.455, 2.705) then 0.5
        when chi_square_value.between?(2.706, 3.840) then 0.1
        when chi_square_value.between?(3.841, 5.411) then 0.05
        when chi_square_value.between?(5.412, 6.634) then 0.02
        when chi_square_value.between?(6.635, 10.826) then 0.01
        when chi_square_value >= 10.827 then 0.001
      end
    1 - alpha
  end

  def print_tests_and_successes
    puts "A tests: #{@a_trials} A successes: #{@a_successes}"
    puts "B tests: #{@b_trials} A successes: #{@b_successes}"
  end

  def print_conversion_rates(a_range, b_range)
    puts "95%% of the times, A's conversion rate ranges from %3.2f%% to %3.2f%%" % [a_range.min * 100, a_range.max * 100]
    puts "95%% of the times, B's conversion rate ranges from %3.2f%% to %3.2f%%" % [b_range.min * 100, b_range.max * 100]
  end

  def print_winner_and_confidence_level(a_conversion_rate, b_conversion_rate, confidence_level)
    if (a_conversion_rate > b_conversion_rate)
      puts "A is the winner"
    else
      puts "B is the winner"
    end
    puts "The confidence level in these findings is #{confidence_level * 100}%"
  end
end
