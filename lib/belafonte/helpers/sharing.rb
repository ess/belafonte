require 'belafonte/senora'

module Belafonte
  module Helpers
    module Sharing
      def share(key, value)
        Belafonte::Senora.store(key, value)
      end

      def partake(key)
        Belafonte::Senora.retrieve(key)
      end
    end
  end
end
