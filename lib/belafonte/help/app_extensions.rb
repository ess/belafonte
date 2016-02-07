module Belafonte
  module Help
    module AppExtensions
      def root
        return self unless parent
        parent.extend(AppExtensions)
        parent.root
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

      def command_arg
        return '' unless show_command_arg?
        ' command'
      end

      def show_command_arg?
        Belafonte::Help::Generator.target == self && has_subcommands?
      end

      def display_flags(cmd)
        return '' unless has_flags?
        " [#{cmd} options]"
      end

      def display_args
        return '' unless has_args?
        " #{non_command_arg_names.join(' ')}"
      end

      def non_command_arg_names
        non_command_args.map(&:name).map(&:to_s)
      end

      def signature
        display_title.tap {|cmd|
          return cmd + display_flags(cmd) + display_args + command_arg
        }
      end

      def has_flags?
        configured_switches.any? || configured_options.any?
      end

      def non_command_args
        configured_args.reject {|arg| arg.name.to_sym == :command}
      end

      def has_args?
        non_command_args.any?
      end

      def has_subcommands?
        configured_subcommands.any?
      end

      def help_flag
        @help_flag ||= Belafonte::Switch.new(name: :help, short: 'h', long: 'help', description: 'Shows this message')
      end

      def sorted_flags
        (configured_switches + configured_options).
          sort {|left,right| left.name <=> right.name}
      end

      def sorted_commands
        configured_subcommands.
          sort {|left,right| left.name <=> right.name}
      end
    end
  end
end
