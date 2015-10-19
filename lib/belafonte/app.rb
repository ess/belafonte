require 'optparse'
require 'belafonte/dsl'
require 'belafonte/errors'

module Belafonte
  class App
    include Belafonte::DSL

    attr_reader :argv, :stdin, :stdout, :stderr, :kernel

    def initialize(argv, stdin = STDIN, stdout = STDOUT, stderr = STDERR, kernel = Kernel, parent = nil)
      @argv = argv
      @stdin = stdin
      @stdout = stdout
      @stderr = stderr
      @kernel = kernel
      @parent = parent
      setup_subcommands!
    end

    private
    def parent
      @parent
    end
  end
end
