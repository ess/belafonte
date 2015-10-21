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
        "NAME\n#{Wrapomatic.new("#{app.display_title} - #{app.summary}").wrapped}\n"
      end

      def synopsis
        synopsis = "\nSYNOPSIS\n#{Wrapomatic.new(app.full_path).wrapped}"
        if app.description
          synopsis += "\n\n#{Wrapomatic.wrap(app.display_description)}"
        end
        synopsis + "\n"
      end

      def options
        return '' unless app.has_flags?
        options = "\nOPTIONS\n"
        app.sorted_flags.each do |flag|
          flag.extend(FlagExtensions)
          options += "#{Wrapomatic.new(flag.signature).wrapped}"
        end

        options + "\n"
      end

      def commands
        return '' unless app.has_subcommands?
        commands = "\nCOMMANDS\n"

        app.sorted_commands.each do |command|
          command.extend(CommandExtensions)
          commands += "#{Wrapomatic.new("#{command.display_title} - #{command.display_summary}").wrapped}\n"
        end

        commands + "\n"
      end
    end
  end
end
