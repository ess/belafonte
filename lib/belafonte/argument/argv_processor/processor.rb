require 'belafonte/errors'

module Belafonte
  class Argument
    module ARGVProcessor
      class Processor
        attr_reader :occurrences, :arguments

        def initialize(occurrences, arguments)
          @occurrences, @arguments = occurrences, arguments
        end

        def processed
          validate_arguments
          arguments.first(occurrences)
        end

        private
        def validate_arguments
          raise Errors::TooFewArguments.new("Not enough arguments were given") unless valid_arguments_length?
        end

        def valid_arguments_length?
          arguments.length >= occurrences
        end
      end
    end
  end
end
