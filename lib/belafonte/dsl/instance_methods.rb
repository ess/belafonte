require 'optparse'

module Belafonte
  module DSL
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

      def configured_options
        self.class.info(:options)
      end

      def configured_switches
        self.class.switches
      end

      def switches
        @switches ||= {}
      end

      def switch_active(switch)
        switches[switch]
      end

      def args
        @args ||= []
      end

      def execute!
        #before
        if help_active?
          stdout.puts parser
          kernel.exit 0
        else
          if respond_to?(:handle)
            handle
          else
            stdout.puts "I have no handler"
          end
        end

        #after
        return 0
      end

      private
      def parser
        @parser
      end

      def short(option)
        "-#{option.to_s}"
      end

      def long(option)
        "-#{short(option)}"
      end

      def help
        @help ||= false
      end

      def activate_help!
        @help = true
      end

      def help_active?
        help
      end

      def setup_parser!
        @parser = OptionParser.new do |opts|
          opts.separator ""
          opts.separator "Specific options:"

          configured_switches.each do |switch|
            opts.on(*(switch.to_opt_parse)) do
              switch.flags.each do |flag|
                switches[flag] = true
              end
            end
          end

          opts.on_tail('-h', '--help', 'Prints the help for the command') do
            activate_help!
          end
        end
      end
    end
  end
end
