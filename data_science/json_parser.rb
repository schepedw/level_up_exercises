require 'JSON'
class Json_Parser
  attr_reader :cohorts, :parsed_file
  def initialize(file_name)
    @parsed_file = parse(file_name)
    @cohorts = {}
    separate_cohorts_and_results
  end

  private

  def separate_cohorts_and_results
    parsed_file.each  do |log_entry|#could be refactored to inject
     increment_cohort(log_entry) 
    end
  end

  def increment_cohort(log_entry)
    unless log_entry["result"] == 0 || log_entry["result"] == 1 
      raise ArgumentError, "Result cannot be #{log_entry["result"]}, only 0 | 1"
    end
    cohort_name = log_entry["cohort"]
    cohorts[ cohort_name ] ||= {"successes" => 0, "trials" => 0}
    cohorts[ cohort_name ] ["successes"] += log_entry["result"]
    cohorts[ cohort_name ] ["trials"] += 1
  end

  def parse(file_string)
    JSON.parse(IO.read(file_string))
  end

end

