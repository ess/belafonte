module Belafonte
  module DSL
    module ClassMethods
      def meta
        @meta ||= {
          title: "",
          summary: "",
          description: "",
          arguments: [],
          flags: [],
          switches: []
        }
      end

      def title(title)
        meta[:title] = title
      end

      def summary(summary)
        meta[:summary] = summary
      end

      def description(description)
        meta[:description] = description
      end

      def info(datum)
        meta[datum]
      end
    end
  end
end
