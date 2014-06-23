require './json_parser.rb'
require 'pry'
class Split_Test
  CONVERT_SSE_TO_GIVE_95PERCENT_CONFIDENCE = 1.96
  attr_reader :trials,:successes, :failures, :standard_squared_error, :conversion_rate, :conversion_range

  def initialize(trials, successes)
    @trials = trials
    @successes = successes
    @failures = trials - successes
    @conversion_rate = calculate_conversion_rate(@trials, @successes)
    @standard_squared_error = calculate_SSE(@conversion_rate, @successes)
    @conversion_range = calculate_conversion_range(@standard_squared_error, @conversion_rate)
  end

  def calculate_conversion_rate(trial_count, successes_count)
    1.0 * successes_count / trial_count
  end

  def calculate_SSE(conversion_rate, num_trials)
    Math.sqrt(conversion_rate * (1.0 - conversion_rate) / num_trials)
  end

  def calculate_conversion_range(sse, conversion_rate)
    sse *= CONVERT_SSE_TO_GIVE_95PERCENT_CONFIDENCE
    low = conversion_rate - sse
    high = conversion_rate + sse
    low .. high
  end

  def calculate_chi_squared_value(a_successes = @successes, a_failures = @failures, b_successes, b_failures)
    total = a_successes + a_failures + b_successes + b_failures
    1.0 * total * (a_successes * b_failures - b_successes * a_failures) ** 2 /
      ((a_successes + a_failures) * (a_successes + b_successes) * (b_successes + b_failures) *
        (a_failures + b_failures))
  end

  def calculate_confidence_level(chi_square_value) 
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


end
