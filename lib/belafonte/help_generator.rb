module Belafonte
  class HelpGenerator
    def initialize(app)
      @app = app
    end

    def name_section
      name = "NAME\n  #{app.root? ? $0 : app.title} - #{app.summary}"
      if app.description
        name += "\n\n  #{app.description}"
      end
      name
    end

    def synopsis_section
      synopsis = "SYNOPSIS\n  #{app.title}"

      if has_flags
        synopsis += " [options]"
      end

      if has_args
        synopsis += args.map(&:name).join(' ')
      end

      synopsis
    end

    def options_section
      options = "OPTIONS\n\n"

      switches
      options += "  -h, --help\tShow this help message"

    end

    private
    def app
      @app
    end

    def switches
      app.configured_switches
    end

    def options
      app.configured_options
    end

    def args
      app.configured_args
    end

    def has_flags?
      switches.length + length > 0
    end

    def has_args?
      args.length > 0
    end
  end
end
