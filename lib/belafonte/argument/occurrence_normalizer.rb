require 'belafonte/argument/occurrence_normalizer/normalizer'
require 'belafonte/argument/occurrence_normalizer/unlimited'
require 'belafonte/argument/occurrence_normalizer/single'

module Belafonte
  class Argument
    module OccurrenceNormalizer
      DEFAULT = Normalizer
      SPECIAL = {
        :unlimited => Unlimited,
        nil => Single
      }

      def self.normalize(occurrences)
        (SPECIAL[occurrences] || DEFAULT).new(occurrences).normalized
      end
    end
  end
end
