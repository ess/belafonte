require 'belafonte/help/generator'

module Belafonte
  # Generates the help for a given app
  module Help

    def self.content_for(app)
      Generator.new(app).content
    end
  end
end
