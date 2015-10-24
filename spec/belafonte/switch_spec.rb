require 'spec_helper'
require 'belafonte/switch'

module Belafonte
  describe Switch do

    it 'is a kind of Flag' do
      expect(described_class.new(name: :face, short: 'f')).
        to be_a(Belafonte::Flag)
    end
  end
end
