require 'belafonte/errors'

module Belafonte
  # Processes command line arguments
  class ArgumentProcessor
    def initialize(options = {})
      @argv = options[:argv] || []
      @arguments = options[:arguments] || []
      process!
    end

    def processed
      @processed ||= {}
    end

    private
    def process!
      argv = @argv.clone
      arguments.each do |arg|
        values = arg.process(argv)
        processed[arg.name] = values
        argv.shift(values.length)
      end

      validate_processed_args

      if argv.length > 0
        raise Belafonte::Errors::TooManyArguments.new("More args provided than I can handle")
      end
    end

    def arguments
      @arguments
    end

    def validate_processed_args
      raise Belafonte::Errors::TooFewArguments.new("You didn't provide enough arguments") if processed.values.any? {|arg| arg.empty?}
    end
  end
end
