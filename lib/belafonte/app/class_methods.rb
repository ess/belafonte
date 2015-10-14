module Belafonte
  module App
    module ClassMethods
      def register_command(command)
        commands.push(command)
      end

      def commands
        meta[:commands] ||= []
      end
    end
  end
end
