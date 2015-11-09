require 'wrapomatic'
require 'belafonte/help/app_extensions'
require 'belafonte/help/flag_extensions'
require 'belafonte/help/command_extensions'

module Belafonte
  module Help
    class Generator
      def self.set_target(app)
        @target = app
      end

      def self.target
        @target
      end

      def initialize(app)
        self.class.set_target(@app = app)
        app.extend(AppExtensions)
        @content = name_section + synopsis + options + commands
      end

      def content
        @content
      end

      private
      def app
        @app
      end

      def name_section
        "NAME\n#{Wrapomatic.wrap("#{app.display_title} - #{app.summary}", indents: 1)}\n"
      end

      def synopsis
        synopsis = "\nSYNOPSIS\n#{Wrapomatic.wrap(app.full_path, indents: 1)}"
        if app.description
          synopsis += "\n\n#{Wrapomatic.wrap(app.display_description, indents: 1)}"
        end
        synopsis + "\n"
      end

      def options
        options = "\nOPTIONS\n"
        app.sorted_flags.each do |flag|
          flag.extend(FlagExtensions)
          options += "#{Wrapomatic.wrap(flag.signature, indents: 1)}\n"
        end
        options += "#{Wrapomatic.wrap('-h, --help - Shows this message', indents: 1)}"

        options + "\n"
      end

      def commands
        return '' unless app.has_subcommands?
        commands = "\nCOMMANDS\n"

        app.sorted_commands.each do |command|
          command.extend(CommandExtensions)
          commands += "#{Wrapomatic.wrap("#{command.display_title} - #{command.display_summary}", indents: 1)}\n"
        end

        commands + "\n"
      end
    end
  end
end
