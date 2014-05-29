RSpec::Matchers.define :match_date do |expected_string|
  match do |actual_date|
    format_date(actual_date) == expected_string
  end

  def format_date date
    "%d-%02d-%02d" % [date.year, date.month, date.day]
  end

  failure_message do |actual|
    "expected that '#{format_date(actual)}' would match #{expected_string}"
  end

  failure_message_when_negated do |actual|
    "expected that '#{format_date(actual)}' would not match #{expected_string}"
  end

  description do
    "be a date matching #{expected_string}"
  end
end
