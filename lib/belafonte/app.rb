require 'optparse'
require 'belafonte/dsl'

module Belafonte
  class App
    include Belafonte::DSL

    attr_reader :argv, :stdin, :stdout, :stderr, :kernel

    def initialize(argv, stdin = STDIN, stdout = STDOUT, stderr = STDERR, kernel = Kernel)
      @argv = argv
      @stdin = stdin
      @stdout = stdout
      @stderr = stderr
      @kernel = kernel
      setup_parser!
      @args = parser.parse(argv)
      begin
        process_args!
      rescue Belafonte::Argument::NotEnoughData => e
        activate_help!
      end
    end
  end
end
