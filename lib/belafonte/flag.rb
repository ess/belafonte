module Belafonte
  class Flag
    NoFlags = Class.new(StandardError)
    NoName = Class.new(StandardError)

    attr_reader :name, :short, :long, :description

    def normalize_flag(flag)
      flag.to_s.strip.gsub(/\s+/, '-')
    end

    def initialize(options = {})
      unless options[:name]
        raise NoName.new("Flag name cannot be blank")
      end

      @name = options[:name].to_sym

      @short = [options[:short]].
        flatten.
        map {|flag| normalize_flag(flag)}.
        reject {|flag| flag == ''}

      @long = [options[:long]].
        flatten.
        map {|flag| normalize_flag(flag)}.
        reject {|flag| flag == ''}

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

    def variations
      short + long
    end
    alias_method :flags, :variations

    private
    def shortify(option)
      shortened = "-#{option.to_s}"
    end

    def longify(option)
      "--#{option.to_s}"
    end
  end
end
