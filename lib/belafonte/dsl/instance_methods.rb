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

      def execute!
        setup_parser!
        parse_options!

        begin
          process_args!
        rescue Belafonte::Argument::NotEnoughData,
          Belafonte::Argument::TooMuchData => e
          activate_help!
        end

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

      def root
        if parent
          parent.root
        else
          self
        end
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

      def setup_subcommands!
        configured_subcommands.each do |sub|
          subcommands.push(sub.new(argv, stdin, stdout, stderr, kernel, self))
        end
      end

      def root?
        root == self
      end

      def process_args!
        temp_argv = @args.clone
        configured_args.each do |arg|
          values = arg.process(temp_argv)
          args[arg.name] = values
          temp_argv.shift(values.length)
        end

        if temp_argv.length > 0
          raise Belafonte::Argument::TooMuchData.new("More args provided than I can handle")
        end
      end

      def setup_parser!
        @parser = OptionParser.new do |opts|
          opts.separator ""
          opts.separator "Specific options:"

          configured_switches.each do |switch|
            opts.on(*(switch.to_opt_parse)) do
              switches[switch.name] = true
            end
          end

          configured_options.each do |option|
            opts.on(*(option.to_opt_parse)) do |value|
              options[option.name] = value
            end
          end

          opts.on_tail('-h', '--help', 'Prints this help message') do
            activate_help!
          end
        end
      end

      def parse_options!
        @args = @parser.parse(argv)
      end
    end
  end
end
