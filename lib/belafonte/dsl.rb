require 'belafonte/dsl/class_methods'

module Belafonte
  module DSL
    def self.included(klass)
      klass.extend(Belafonte::DSL::ClassMethods)
    end

    def title
      self.class.info(:title)
    end

    def summary
      self.class.info(:summary)
    end

    def description
      self.class.info(:description)
    end

    def mount(blah)

    end

    def exit(status)
      kernel.exit(status)
    end
  end
end
