require 'optparse'
require 'belafonte/dsl'

module Belafonte
  class App
    include Belafonte::DSL

    attr_reader :argv, :stdin, :stdout, :stderr, :kernel, :parent

    def initialize(argv, stdin = STDIN, stdout = STDOUT, stderr = STDERR, kernel = Kernel, parent = nil)
      @argv = argv
      @stdin = stdin
      @stdout = stdout
      @stderr = stderr
      @kernel = kernel
      setup_parser!
      @args = parser.parse(argv)
      process_args!
    end
  end
end
