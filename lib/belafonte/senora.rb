module Belafonte
  module Senora
    def self.store(key, value)
      data[key] = value
    end

    def self.retrieve(key)
      data[key]
    end

    def self.data
      @data ||= {}
    end
  end
end
