require 'belafonte/dsl/instance_methods'
require 'belafonte/dsl/class_methods'
require 'belafonte/dsl/sharing'

module Belafonte
  # A DSL for making apps
  module DSL
    def self.included(klass)
      klass.extend(Belafonte::DSL::ClassMethods)
    end

    include Belafonte::DSL::InstanceMethods
    include Belafonte::DSL::Sharing
  end
end
