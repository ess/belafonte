require 'belafonte/flag'

module Belafonte
  class Option < Belafonte::Flag
    NoArgument = Class.new(StandardError)

    def initialize(options = {})
      super(options)
      options[:argument].tap do |arg|
        raise NoArgument.new("Option requires an argument name") unless arg
        @argument = arg.to_s.strip.upcase.gsub(/\s+/, '_')
      end
    end

    private
    def shortify(option)
      "#{super(option)} #{@argument}"
    end

    def longify(option)
      "#{super(option)}=#{@argument}"
    end
  end
end
