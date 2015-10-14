require 'belafonte/command'

module Belafonte
  module Command
    class Help
      include Belafonte::Command

      title :help
      summary 'Get help for the app'

      def run
        stdout.puts("This is where the help would go, but I'm not done yet.")
        stdout.puts("Instead, here's the list of supported commands:\n")
        stdout.puts application.commands.
          map {|command| command.info(:title)}.join("\n")
      end
    end
  end
end
