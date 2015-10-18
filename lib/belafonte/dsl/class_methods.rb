require 'optparse'
require 'belafonte/switch'

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

      def switch(switch_options = {})
        switches.push(Belafonte::Switch.new(switch_options))
      end

      def args
        meta[:args] ||= {}
      end

      def arg(name, options = {})
        options[:times] ||= 1
        name = name.to_s
        args[name] = options
      end
    end
  end
end
