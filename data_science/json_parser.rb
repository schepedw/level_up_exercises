require 'JSON'
class JSON_Parser
  attr_reader :parsed_file, :a_successes, :a_failures, :b_successes, :b_failures
  def initialize(file_name)
    @parsed_file = parse(file_name)
    @a_successes = 0
    @a_failures = 0
    @b_successes = 0
    @b_failures = 0
    separate_cohorts_and_results
  end

  def get_all_a_trials
    @a_failures + @a_successes
  end

  def get_all_b_trials
    @b_failures + @b_successes
  end

  private

  def separate_cohorts_and_results
    @parsed_file.each  do |log_entry|
      if log_entry["result"] == 1
        increment_successes(log_entry)
      else
        increment_failures(log_entry)
      end
    end
  end

  def parse(file_string)
    JSON.parse(IO.read(file_string))
  end

  def increment_failures(log_entry)
    if log_entry["cohort"] == "A" 
      @a_failures += 1
    else 
      @b_failures +=1
    end
  end

  def increment_successes(log_entry)
    if log_entry["cohort"] == "A" 
      @a_successes += 1
    else 
      @b_successes +=1
    end
  end

end

