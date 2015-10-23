module Belafonte
  module Helpers
    # Instance methods for apps
    module Restricted
      protected

      def activate_help!
        @help = true
      end

      private

      def help
        @help ||= false
      end

      def help_active?
        help
      end
    end
  end
end
