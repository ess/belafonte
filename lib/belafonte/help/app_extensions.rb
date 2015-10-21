module Belafonte
  module Help
    module AppExtensions
      def root
        if parent
          parent.extend(AppExtensions)
          parent.root
        else
          self
        end
      end

      def root?
        root == self
      end

      def executable
        File.basename($0)
      end

      def display_title
        root? ? executable : title
      end

      def display_description
        description.to_s
      end

      def full_path
        return signature unless parent
        parent.extend(AppExtensions)
        "#{parent.full_path} #{signature}"
      end

      def signature
        cmd = display_title

        cmd += " [#{cmd} options]" if has_flags?

        if has_args?
          cmd += " #{configured_args.map(&:name).map(&:to_s).join(' ')}"
        end

        if has_subcommands? && @command.nil?
          cmd += " command"
        end

        cmd
      end

      def has_flags?
        configured_switches.any? || configured_options.any?
      end

      def has_args?
        configured_args.reject {|arg| arg.name.to_sym == :command}.any?
      end

      def has_subcommands?
        configured_subcommands.any?
      end

      def sorted_flags
        (configured_switches + configured_options).sort {|a,b| a.name <=> b.name}
      end

      def sorted_commands
        configured_subcommands.sort {|a,b| a.name <=> b.name}
      end
    end
  end
end
