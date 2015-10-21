require 'belafonte/flag'

module Belafonte
  # Flags that take arguments
  class Option < Belafonte::Flag
    # No argument given
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
