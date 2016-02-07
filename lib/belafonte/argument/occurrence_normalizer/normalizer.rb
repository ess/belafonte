module Belafonte
  class Argument
    module OccurrenceNormalizer
      class Normalizer
        attr_reader :occurrences

        def initialize(occurrences)
          @occurrences = occurrences
        end

        def normalized
          Integer(occurrences)
        end
      end
    end
  end
end
