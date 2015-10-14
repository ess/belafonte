require 'belafonte/app/class_methods'
require 'belafonte/dsl'
require 'belafonte/command/help'

module Belafonte
  module App
    def self.included(klass)
      klass.extend(Belafonte::App::ClassMethods)
      klass.class_eval do
        include Belafonte::DSL

        attr_reader :argv, :stdin, :stdout, :stderr, :kernel,
          :global_flags, :global_switches, :command_flags, :commmand_switches,
          :parent
        
        register_command Belafonte::Command::Help

        def initialize(argv, stdin = STDIN, stdout = STDOUT, stderr = STDERR, kernel = Kernel, parent = nil)

          @argv = argv
          @stdin = stdin
          @stdout = stdout
          @stderr = stderr
          @kernel = kernel
          @parent = parent
          @global_switches = []
        end
      end
    end

    def execute!
      before
      run
      after
    end

    def before
      true
    end

    def after
      true
    end

    def user_command
      ''
    end

    def run
      if user_command == ''
        command(:help).execute!
      end
    end

    def command(name)
      command_instances.find {|command| command.title.to_s == name.to_s}
    end

    def commands
      self.class.commands
    end

    def command_instances
      commands.map {|command|
        command.new(argv, stdin, stdout, stderr, kernel, self)
      }
    end

    def application
      @application ||= case parent
                       when nil
                         self
                       else
                         parent.application
                       end
    end
  end
end
