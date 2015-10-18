module Belafonte
  class Switch
    NoFlags = Class.new(StandardError)

    attr_reader :short, :long, :description

    def normalize_flag(flag)
      flag.to_s.strip.gsub(/\s+/, '-')
    end

    def initialize(options = {})
      @short = [options[:short]].
        flatten.
        map {|flag| normalize_flag(flag)}.
        reject {|flag| flag == ''}

      @long = [options[:long]].
        flatten.
        map {|flag| normalize_flag(flag)}.
        reject {|flag| flag == ''}

      if short.empty? && long.empty?
        raise NoFlags.new("You must define at least one flag for the switch")
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

    def active?
      @active ||= false
    end

    def activate!
      @active = true
    end

    def flags
      short + long
    end

    private
    def shortify(option)
      shortened = "-#{option.to_s}"
    end

    def longify(option)
      "--#{option.to_s}"
    end
  end
end
