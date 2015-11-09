require 'optparse'
require 'belafonte/errors'
require 'belafonte/help'
require 'belafonte/parser'
require 'belafonte/helpers'
require 'wrapomatic'

module Belafonte
  module Rhythm
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

      begin
        validator = Belafonte::Validator.new(self.class)
        unless validator.valid?
          raise "The application #{validator.app_title} has the following issues: #{validator.errors}"
        end
        run_setup

        if dispatch || show_help || run_handle
          return 0
        else
          stderr.puts "No handler for the provided command line"
          return 1
        end
      rescue => uncaught_error
        stderr.puts "The application encountered the following error:"
        stderr.puts Wrapomatic.wrap(uncaught_error.to_s, indents: 1)
        return 255
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

    def run_setup
      return nil unless respond_to?(:setup)
      setup
    end
  end
end
