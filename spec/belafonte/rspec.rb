require 'rspec/expectations'
require 'belafonte/validator'

RSpec::Matchers.define :be_a_valid_belafonte_app do
  app_errors = {}
  match do |app|
    validator = Belafonte::Validator.new(app)
    valid = validator.valid?
    app_errors = validator.errors
    valid
  end
  failure_message_for_should do |actual|
    validator = Belafonte::Validator.new(actual)
    validator.valid?
    "expected that #{actual} would be a valid Belafonte app (issues: #{validator.errors})"
  end
  failure_message_when_negated do |actual|
    "expected that #{actual} would not be a valid Belafonte app"
  end
end
