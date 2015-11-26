require 'belafonte/errors'
require 'optionally/required'

module Belafonte
  # Processes command line arguments
  class ArgumentProcessor
    include Optionally::Required

    def initialize(options = {})
      check_required_options(options, :argv, :arguments)

      @argv = options[:argv]
      @arguments = options[:arguments]
      process
    end

    def processed
      @processed ||= {}
    end

    private
    def process
      argv = @argv.clone
      arguments.each do |arg|
        values = arg.process(argv)
        if arg.unlimited? && values.empty?
          values.push('')
        end
        processed[arg.name] = values
        argv.shift(values.length)
      end

      if argv.length > 0
        raise Errors::TooManyArguments.new("More args provided than I can handle")
      end
    end

    def arguments
      @arguments
    end
  end
end
