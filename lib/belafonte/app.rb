require 'optparse'
require 'belafonte/dsl'
require 'belafonte/errors'
require 'belafonte/help'

module Belafonte
  # An application container
  class App
    include Belafonte::DSL

    attr_reader :argv, :stdin, :stdout, :stderr, :kernel

    def initialize(argv, stdin = STDIN, stdout = STDOUT, stderr = STDERR, kernel = Kernel, parent = nil)
      @argv = argv
      @stdin = stdin
      @stdout = stdout
      @stderr = stderr
      @kernel = kernel
      @parent = parent
    end

    def execute!
      (@parser = Parser.new(
        switches: configured_switches,
        options: configured_options,
        commands: configured_subcommands,
        arguments: configured_args,
        argv: @argv
      )).parsed.tap do |parsed|
        @switches = parsed[:switches]
        @options = parsed[:options]
        @arguments = parsed[:args]
        activate_help! if parsed[:help]
      end

      @command = arg(:command).shift if arg(:command)

      unless dispatch || show_help || run_handle
        stderr.puts "No handler for the provided command line"
        return 1
      end

      0
    end

    private
    def parent
      @parent
    end

    def subcommand_instance(command)
      command_class = configured_subcommands.
        find {|subcommand| subcommand.info(:title) == command}

      return nil unless command_class

      command_class.new(arg(:command), stdin, stdout, stderr, kernel, self)
    end

    def dispatch
      return false if @command.nil?
      handler = subcommand_instance(@command)

      unless handler
        activate_help!
        return false
      end

      handler.activate_help! if help_active?
      handler.execute!
      true
    end

    def show_help
      return false unless help_active?
      stdout.print Belafonte::Help.content_for(self)
      true
    end

    def run_handle
      return false unless respond_to?(:handle)
      handle
      true
    end
  end
end
