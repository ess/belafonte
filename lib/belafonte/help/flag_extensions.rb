module Belafonte
  module Help
    module FlagExtensions
      def short_flags
        short.map {|short_flag| shortify(short_flag)}
      end

      def long_flags
        long.map {|long_flag| longify(long_flag)}
      end

      def signature
        "#{(short_flags + long_flags).join(', ')} - #{description}"
      end
    end
  end
end
