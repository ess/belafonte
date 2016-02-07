require 'belafonte/argument/occurrence_normalizer/normalizer'

module Belafonte
  class Argument
    module OccurrenceNormalizer
      class Single < Normalizer
        def normalized
          occurrences ? nil : 1
        end
      end
    end
  end
end
