module Belafonte
  module Helpers
    module Flags
      def switches
        @switches ||= {}
      end

      def switch_active?(switch)
        switches[switch]
      end

      def options
        @options ||= {}
      end

      def option(option)
        options[option]
      end
    end
  end
end
