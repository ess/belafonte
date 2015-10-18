require 'belafonte/flag'

module Belafonte
  class Switch < Belafonte::Flag
    def active?
      @active ||= false
    end

    def activate!
      @active = true
    end
  end
end
