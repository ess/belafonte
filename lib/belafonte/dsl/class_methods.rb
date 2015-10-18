require 'optparse'
require 'belafonte/switch'
require 'belafonte/option'
require 'belafonte/argument'

module Belafonte
  module DSL
    module ClassMethods
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
        if args.last && args.last.unlimited?
          raise Belafonte::Argument::Invalid.new("You may not add other arguments after an unlimited argument")
        else
          args.push(Belafonte::Argument.new(arg_options.merge({name: name})))
        end
      end
    end
  end
end
