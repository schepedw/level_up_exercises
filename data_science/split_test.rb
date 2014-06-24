require './json_parser.rb'

class Split_Test
  CONVERT_SSE_TO_GIVE_95PERCENT_CONFIDENCE = 1.96

  P_VALUES = {
    (0..0.454) => 0,
    (0.454..2.705) => 0.5,
    (2.705..3.840) => 0.1,
    (3.840..5.411) => 0.05,
    (5.411..6.634) => 0.02,
    (6.634..10.826) => 0.01,
    (10.826..Float::INFINITY) => 0.001
  }

  attr_reader :trials, :successes, :failures

  def initialize(trials, successes)
    raise ArgumentError, "cannot have more successes than trials" unless successes <= trials
    raise ArgumentError, "cannot have 0 trials" unless trials > 0
    raise ArgumentError, "cannot have not-integer trials or successes" unless successes.is_a? Integer and trials.is_a? Integer
    @trials = trials
    @successes = successes
    @failures = trials - successes
  end

  def conversion_rate
    1.0 * successes / trials
  end

  def standard_squared_error
    Math.sqrt(conversion_rate * (1.0 - conversion_rate) / trials)
  end

  def conversion_range
    low = conversion_rate - (standard_squared_error * CONVERT_SSE_TO_GIVE_95PERCENT_CONFIDENCE)
    high = conversion_rate + (standard_squared_error * CONVERT_SSE_TO_GIVE_95PERCENT_CONFIDENCE)
    (low..high)
  end

  def confidence_level_with(other_split_test)
    chi_squared_value = chi_squared_value(other_split_test)
    p_range = P_VALUES.detect{|range, _| range.include? chi_squared_value}
    p_value = p_range[1]
    1 - p_value
  end

  private

  def chi_squared_value(other_split_test)
    #raise ArgumentError, "#{other_split_test} must have successes & failures"
    b_successes = other_split_test.successes
    b_failures = other_split_test.failures
    total = successes + failures + b_successes + b_failures
    1.0 * total * (successes * b_failures - b_successes * failures) ** 2 /
      ((successes + failures) * (successes + b_successes) * (b_successes + b_failures) *
        (failures + b_failures))
  end

end
