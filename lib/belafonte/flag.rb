require 'belafonte/errors'

module Belafonte
  # Flag is the base class for switches and options
  class Flag
    # No flags were given
    NoFlags = Class.new(StandardError)
    # No name was given
    NoName = Class.new(StandardError)

    attr_reader :name, :short, :long, :description

    def self.shortify(option)
      "-#{option}"
    end

    def self.longify(option)
      "--#{option}"
    end

    def self.normalize_flag(flag)
      flag.to_s.strip.gsub(/\s+/, '-')
    end

    def initialize(options = {})
      options[:name].tap do |name|
        unless name
          raise Errors::NoName.new("Flag name cannot be blank")
        end
        @name = name.to_sym
      end

      @short = flag_array(options[:short])
      @long = flag_array(options[:long])

      if short.empty? && long.empty?
        raise NoFlags.new("You must define at least one flag")
      end

      @description = options[:description] || ''
    end

    def to_opt_parse
      [
        short.map {|short_option| shortify(short_option)},
        long.map {|long_option| longify(long_option)},
        description
      ].flatten
    end

    private
    def shortify(option)
      self.class.shortify(option)
    end

    def longify(option)
      self.class.longify(option)
    end

    def normalize_flag(flag)
      self.class.normalize_flag(flag)
    end

    def flag_array(items)
      [items].
        flatten.
        map {|flag| normalize_flag(flag)}.
        reject {|flag| flag.eql?('')}
    end
  end
end
