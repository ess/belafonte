module Belafonte
  module Errors
    CircularMount = Class.new(StandardError)
    InvalidArgument = Class.new(StandardError)
    NoName = Class.new(StandardError)
    ArgumentNotNamed = Class.new(StandardError)
    TooFewArguments = Class.new(StandardError)
    TooManyArguments = Class.new(StandardError)
  end
end
