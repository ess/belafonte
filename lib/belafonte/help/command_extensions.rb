module Belafonte
  module Help
    module CommandExtensions
      def display_title
        info(:title).to_s
      end

      def display_summary
        info(:summary).to_s
      end
    end
  end
end
