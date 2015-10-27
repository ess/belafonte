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

      def command_arg
        if Belafonte::Help::Generator.target == self && has_subcommands?
          ' command'
        else
          ''
        end
      end

      def display_flags(cmd)
        if has_flags?
          " [#{cmd} options]"
        else
          ''
        end
      end

      def display_args
        if has_args?
          " #{non_command_args.map(&:name).map(&:to_s).join(' ')}"
        else
          ''
        end
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
        (configured_switches + configured_options).sort {|a,b| a.name <=> b.name}
      end

      def sorted_commands
        configured_subcommands.sort {|a,b| a.name <=> b.name}
      end
    end
  end
end
