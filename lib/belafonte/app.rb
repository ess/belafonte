require 'belafonte/dsl'
require 'belafonte/rhythm'
require 'belafonte/validator'

module Belafonte
  # An application container
  class App
    include Belafonte::DSL
    include Belafonte::Helpers
    include Belafonte::Rhythm

    attr_reader :argv, :stdin, :stdout, :stderr, :kernel

    def initialize(argv, stdin = STDIN, stdout = STDOUT, stderr = STDERR, kernel = Kernel, parent = nil)
      @argv = argv
      @stdin = stdin
      @stdout = stdout
      @stderr = stderr
      @kernel = kernel
      @parent = parent
    end

  end
end
