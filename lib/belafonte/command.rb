require 'belafonte/command/class_methods'
require 'belafonte/dsl'

module Belafonte
  module Command
    def self.included(klass)
      klass.extend(ClassMethods)
      klass.class_eval do
        include Belafonte::DSL

        attr_reader :application

        def initialize(application)
          @application = application
        end

        def execute!
          before_run
          run
          after_run
        end

        def before_run
          true
        end

        def after_run
          true
        end

        def run
          raise "You must define #{self.class}#run"
        end

        def stdout
          application.stdout
        end

        def stdin
          application.stdin
        end

        def stderr
          application.stderr
        end

        def user_flags
          application.command_flags
        end

        def user_switches
          application.command_switches
        end
      end
    end
  end
end
