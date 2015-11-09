require 'belafonte/switch'
require 'belafonte/option'
require 'belafonte/argument'
require 'belafonte/errors'

module Belafonte
  module DSL
    # Class methods for defining apps
    module Definition
      def meta
        @meta ||= {}
      end

      def info(item)
        meta[item]
      end

      def title(title)
        meta[:title] = title
      end

      def summary(summary)
        meta[:summary] = summary
      end

      def description(description)
        meta[:description] = description
      end

      def switches
        meta[:switches] ||= []
      end

      def switch(name, switch_options = {})
        switches.push(Belafonte::Switch.new(switch_options.merge({name: name})))
      end

      def options
        meta[:options] ||= []
      end

      def option(name, option_options = {})
        options.push(Belafonte::Option.new(option_options.merge({name: name})))
      end

      def args
        meta[:args] ||= []
      end

      def arg(name, arg_options = {})
        args.push(Belafonte::Argument.new(arg_options.merge({name: name})))
      end

      def subcommands
        meta[:subcommands] ||= []
      end

      def mount(app)
        unless args.any? {|arg| arg.name.to_sym == :command}
          arg :command, times: :unlimited
        end

        raise Belafonte::Errors::CircularMount.new("An app cannot mount itself") if app == self
        subcommands.push(app)
      end

      def has_unlimited_arg?
        !(args.find {|arg| arg.unlimited?}).nil?
      end
    end
  end
end
