module Belafonte
  module Helpers
    module MetaData
      def title
        self.class.info(:title)
      end

      def summary
        self.class.info(:summary)
      end

      def description
        self.class.info(:description)
      end

      def configured_switches
        self.class.switches
      end

      def configured_options
        self.class.options
      end

      def configured_args
        self.class.args
      end

      def configured_subcommands
        self.class.subcommands
      end
    end
  end
end
