require 'optparse'
require 'belafonte/argument_processor'

module Belafonte
  # A service object that parses out argv
  class Parser
    def initialize(params = {})
      @data = {
        switches: params[:switches] || [],
        options: params[:options] || [],
        commands: params[:commands] || [],
        arguments: params[:arguments] || [],
        argv: params[:argv] || []
      }
      setup
      parse
    end

    def parsed
      @parsed ||= {
        switches: {},
        options: {},
        args: {},
      }
    end

    def parser
      @parser ||= OptionParser.new
    end

    private

    def setup
      parsify_switches
      parsify_options
      add_help
    end

    def parsify_switches
      switches.each do |switch|
        parser.on(*(switch.to_opt_parse)) do
          switch_results[switch.name] = true
        end
      end
    end

    def parsify_options
      options.each do |option|
        parser.on(*(option.to_opt_parse)) do |value|
          option_results[option.name] = value
        end
      end
    end

    def add_help
      parser.on_tail('-h', '--help', 'Shows this message') do
        parsed[:help] = true
      end
    end

    def parse
      begin
        parsed[:args] = ArgumentProcessor.new(
          argv: parser.order(argv),
          arguments: arguments
        ).processed
      rescue Errors::TooFewArguments, Errors::TooManyArguments
        parsed[:help] = true
      end
    end

    def switches
      data[:switches]
    end

    def switch_results
      parsed[:switches]
    end

    def option_results
      parsed[:options]
    end

    def options
      data[:options]
    end

    def commands
      data[:commands]
    end

    def arguments
      data[:arguments]
    end

    def argv
      data[:argv]
    end

    def data
      @data
    end
  end
end
