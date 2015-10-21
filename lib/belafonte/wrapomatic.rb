module Belafonte
  class Wrapomatic
    attr_reader :text, :lines, :indents, :columns

    def self.wrap(text, indents = 1, columns = 80)
      new(text, indents, columns).wrapped
    end

    def initialize(text, indents = 1, columns = 80)
      @text = text
      @indents = indents
      @columns = columns
      @lines = []
      indentomize
    end

    def refresh(text, indents = 1, columns = 80)
      @text = text
      @remainder = ''
      @lines = []
      indentomize
    end

    def wrapped
      lines.join("\n")
    end

    private

    def indentomize
      begin
        @lines.push(next_line)
      end until next_line.nil?
    end

    def next_line
      return nil if text.length == 0
      offset + text_up_to(space_before_location(columns - offset.length - 1))
    end

    def space_before_location(start)
      return start if start > text.length
      text.rindex(/(\s|-)/, start) || start
    end

    def text_up_to(count)
      text.slice!(0 .. count)
    end

    def indentation
      '  '
    end

    def offset
      indentation * indents
    end
  end
end
