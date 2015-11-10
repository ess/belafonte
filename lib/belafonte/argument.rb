require 'belafonte/errors'

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
      case times
      when -1
        argv
      else
        if argv.length < times
          raise Errors::TooFewArguments.new("Not enough arguments were given")
        end
        argv.first(times)
      end.clone
    end

    def unlimited?
      @unlimited ||= false
    end

    private
    def normalize
      raise Errors::NoName.new("Arguments must be named") unless name

      case times
      when nil
        @times = 1
      when :unlimited
        @times = -1
        @unlimited = true
      else
        @times = Integer(times)
      end
      
      raise Errors::InvalidArgument.new("There must be at least one occurrence") unless times > 0 || unlimited?
    end

  end
end
