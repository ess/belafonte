require 'belafonte/errors'

module Belafonte
  class Argument
    attr_reader :name, :times

    def initialize(options = {})
      unless options[:name]
        raise Belafonte::Errors::NoName.new("Arguments must be named")
      end

      @name = options[:name]

      case options[:times]
      when nil
        @times = 1
      when :unlimited
        @times = -1
        @unlimited = true
      else
        @times = options[:times].to_i
        raise Belafonte::Errors::InvalidArgument.new("There must be at least one occurrence") if times < 1
      end
    end

    def process(argv)
      case times
      when -1
        argv
      else
        if argv.length < times
          raise Belafonte::Errors::TooFewArguments.new("Not enough arguments were given")
        end
        argv.first(times)
      end.clone
    end

    def unlimited?
      @unlimited ||= false
    end
  end
end
