require 'belafonte/errors'
require 'belafonte/argument/argv_processor'
require 'belafonte/argument/occurrence_normalizer'

module Belafonte
  # Represents a command line argument
  class Argument
    attr_reader :name, :times

    def initialize(options = {})
      @name = options[:name]
      @times = options[:times]
      normalize
    end

    def process(argv)
      ARGVProcessor.process(times, argv).clone
    end

    def unlimited?
      @unlimited ||= false
    end

    private
    def normalize
      normalize_name
      normalize_times
    end

    def normalize_times
      @unlimited = times.eql?(:unlimited)
      @times = OccurrenceNormalizer.normalize(times)
      validate_occurrences
    end

    def validate_occurrences
      raise Errors::InvalidArgument.new("There must be at least one occurrence") unless times > 0 || unlimited?
    end

    def normalize_name
      raise Errors::NoName.new("Arguments must be named") unless name
      @name = name.to_sym
    end
  end
end
