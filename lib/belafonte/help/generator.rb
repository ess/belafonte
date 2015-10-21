require 'belafonte/wrapomatic'
require 'belafonte/help/app_extensions'
require 'belafonte/help/flag_extensions'
require 'belafonte/help/command_extensions'

module Belafonte
  module Help
    class Generator
      def initialize(app)
        @app = app
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
        "NAME\n#{Wrapomatic.wrap("#{app.display_title} - #{app.summary}")}\n"
      end

      def synopsis
        synopsis = "\nSYNOPSIS\n#{Wrapomatic.wrap(app.full_path)}"
        if app.description
          synopsis += "\n\n#{Wrapomatic.wrap(app.display_description)}"
        end
        synopsis + "\n"
      end

      def options
        options = "\nOPTIONS\n"
        app.sorted_flags.each do |flag|
          flag.extend(FlagExtensions)
          options += "#{Wrapomatic.wrap(flag.signature)}"
        end
        options += "\n#{Wrapomatic.wrap('-h, --help - Shows this message')}"

        options + "\n"
      end

      def commands
        return '' unless app.has_subcommands?
        commands = "\nCOMMANDS\n"

        app.sorted_commands.each do |command|
          command.extend(CommandExtensions)
          commands += "#{Wrapomatic.wrap("#{command.display_title} - #{command.display_summary}")}\n"
        end

        commands + "\n"
      end
    end
  end
end
