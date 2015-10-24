require 'belafonte/dsl/definition'

module Belafonte
  # A DSL for making apps
  module DSL
    def self.included(klass)
      klass.extend(Belafonte::DSL::Definition)
    end
  end
end
