module Belafonte
  class Argument
    NoName = Class.new(StandardError)
    Invalid = Class.new(StandardError)
    NotEnoughData = Class.new(StandardError)

    attr_reader :name, :times

    def initialize(options = {})
      unless options[:name]
        raise NoName.new("Arguments must be named")
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
        raise Invalid.new("There must be at least one occurrence") if times < 1
      end
    end

    def process(argv)
      case times
      when -1
        argv
      else
        if argv.length < times
          raise NotEnoughData.new("Not enough arguments were given")
        end
        argv.first(times)
      end.clone
    end

    def unlimited?
      @unlimited ||= false
    end
  end
end
