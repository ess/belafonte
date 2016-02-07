require 'belafonte/errors'
require 'belafonte/help'
require 'belafonte/parser'
require 'belafonte/helpers'
require 'wrapomatic'

module Belafonte
  module Rhythm
    def execute!
      parse_command_line
      @command = arg(:command).shift if arg(:command)

      kernel.exit calculate_exit_status
    end

    private
    def parent
      @parent
    end

    def calculate_exit_status
      begin
        validate_app
        run_setup

        unless (status = dispatch || show_help || run_handle || nil)
          stderr.puts "No handler for the provided command line"
          return 1
        end

      rescue SystemExit => exit_requested
        return exit_requested.status
      rescue => uncaught_error
        stderr.puts "The application encountered the following error:"
        stderr.puts Wrapomatic.wrap(uncaught_error.to_s, indents: 1)
        return 255
      end

      status
    end

    def parse_command_line
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
    end

    def validate_app
      validator = Belafonte::Validator.new(self.class)
      unless validator.valid?
        raise "The application #{validator.app_title} has the following issues: #{validator.errors}"
      end
    end

    def subcommand_instance(command)
      command_class = configured_subcommands.
        find {|subcommand| subcommand.info(:title) == command}

      return nil unless command_class

      command_class.new(arg(:command), stdin, stdout, stderr, kernel, self)
    end

    def dispatch
      return nil if @command.nil?
      handler = subcommand_instance(@command)

      unless handler
        activate_help!
        return nil
      end

      handler.activate_help! if help_active?
      handler.execute!
    end

    def show_help
      return nil unless help_active?
      stdout.print Belafonte::Help.content_for(self)
      0
    end

    def run_handle
      return nil unless respond_to?(:handle)
      handle
      0
    end

    def run_setup
      return nil unless respond_to?(:setup)
      setup
    end
  end
end
