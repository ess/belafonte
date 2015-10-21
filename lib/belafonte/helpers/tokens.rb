module Belafonte
  module Helpers
    # deprecated tokenizer
    module Tokens
      def command_tokens
        commands.keys
      end
    end
  end
end
