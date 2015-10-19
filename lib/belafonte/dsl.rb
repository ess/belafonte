require 'belafonte/dsl/instance_methods'
require 'belafonte/dsl/class_methods'

module Belafonte
  module DSL
    def self.included(klass)
      klass.extend(Belafonte::DSL::ClassMethods)
    end

    include Belafonte::DSL::InstanceMethods
    #include Belafonte::DSL::Mountin
  end
end
