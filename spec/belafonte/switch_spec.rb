require 'spec_helper'
require 'belafonte/switch'

module Belafonte
  describe Switch do

    it 'is a kind of Flag' do
      expect(described_class.new(name: :face, short: 'f')).
        to be_a(Belafonte::Flag)
    end

    describe '#active?' do
      let(:switch) {described_class.new(name: :identity, short: 'i')}

      it 'is false if the switch has not been activated' do
        expect(switch.active?).to eql(false)
      end

      it 'is true if the switch has been activated' do
        switch.activate!
        expect(switch.active?).to eql(true)
      end
    end

    describe '#activate!' do
      let(:switch) {described_class.new(name: :identity, short: 'i')}

      it 'sets the switch to active' do
        expect(switch.active?).to eql(false)
        switch.activate!
        expect(switch.active?).to eql(true)
      end
    end
  end
end
