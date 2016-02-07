module Belafonte
  module Errors

    # Raised when an app attempts to mount itself
    CircularMount = Class.new(StandardError)
    
    # Raised when creation of an argument breaks the arg rules
    InvalidArgument = Class.new(StandardError)
    
    # Raised when a name is required but not provided
    NoName = Class.new(StandardError)
    
    # ArgumentNotNamed poop
    ArgumentNotNamed = Class.new(StandardError)
    
    # TooFewArguments poop
    TooFewArguments = Class.new(StandardError)
    
    # TooManyArguments poop
    TooManyArguments = Class.new(StandardError)
    
    # UnknownCommand poop
    UnknownCommand = Class.new(StandardError)

    # ExitStatus
    ExitStatus = Class.new(StandardError)
  end
end
