require 'belafonte/parser'

module Belafonte
  module DSL
    # Instance methods for apps
    module InstanceMethods
      def title
        self.class.info(:title)
      end

      def summary
        self.class.info(:summary)
      end

      def description
        self.class.info(:description)
      end

      def configured_switches
        self.class.switches
      end

      def configured_options
        self.class.options
      end

      def configured_args
        self.class.args
      end

      def configured_subcommands
        self.class.subcommands
      end

      def switches
        @switches ||= {}
      end

      def switch_active(switch)
        switches[switch]
      end

      def options
        @options ||= {}
      end

      def option(option)
        options[option]
      end

      def args
        @arguments ||= {}
      end

      def arg(arg)
        args[arg]
      end

      def subcommands
        @subcommands ||= []
      end

      def estate
        @estate ||= {}
      end

      def bequeathed(name, value)
        estate[name] ||= value
      end
      
      def activate_help!
        @help = true
      end

      private

      def parser
        @parser
      end

      #def short(option)
        #"-#{option.to_s}"
      #end

      #def long(option)
        #"-#{short(option)}"
      #end

      def help
        @help ||= false
      end

      def help_active?
        help
      end
    end
  end
end
