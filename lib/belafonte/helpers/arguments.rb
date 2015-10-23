module Belafonte
  module Helpers
    module Arguments
      def args
        @arguments ||= {}
      end

      def arg(arg)
        args[arg]
      end
    end
  end
end
