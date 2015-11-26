require 'belafonte/senora'

module Belafonte
  module Helpers
    module Sharing
      def share(key, value)
        Senora.store(key, value)
      end

      def partake(key)
        Senora.retrieve(key)
      end
    end
  end
end
