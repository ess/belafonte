require 'spec_helper'
require 'belafonte/switch'

module Belafonte
  describe Switch do
    describe '.new' do
      it 'allows a single short name' do
        switch = described_class.new(short: 'j')
        expect(switch.short).to eql(['j'])
      end

      it 'allows an array of short names' do
        switch = described_class.new(short: ['j', 'r'])
        expect(switch.short).to eql(['j', 'r'])
      end

      it 'allows a single long name' do
        switch = described_class.new(long: 'jump in the line')
        expect(switch.long).to eql(['jump-in-the-line'])
      end

      it 'allows an array of long names' do
        switch = described_class.new(long: ['jump in the line', 'rock your body in time'])
        expect(switch.long).
          to eql(['jump-in-the-line', 'rock-your-body-in-time'])
      end

      it 'defaults the description to blank string' do
        switch = described_class.new(short: 'j')
        expect(switch.description).to eql('')

        switch = described_class.new(short: 'r', description: 'rocks your body')
        expect(switch.description).to eql('rocks your body')
      end

      it 'requires that at least one short or one long flag be present' do
        expect {described_class.new}.to raise_error(Belafonte::Switch::NoFlags)
        expect {described_class.new(short: 'j')}.not_to raise_error
        expect {described_class.new(long: 'jump in the line')}.not_to raise_error
      end
    end

    describe '#active?' do
      let(:switch) {described_class.new(short: 'i')}

      it 'is false if the switch has not been activated' do
        expect(switch.active?).to eql(false)
      end

      it 'is true if the switch has been activated' do
        switch.activate!
        expect(switch.active?).to eql(true)
      end
    end

    describe '#activate!' do
      let(:switch) {described_class.new(short: 'i')}

      it 'sets the switch to active' do
        expect(switch.active?).to eql(false)
        switch.activate!
        expect(switch.active?).to eql(true)
      end
    end

    describe '#flags' do
      let(:switch) {described_class.new(short: ['j', 'r'], long: ['jump', 'rock'], description: 'okay, I believe you')}

      it 'is an array' do
        expect(switch.flags).to be_a(Array)
      end

      it 'contains all of the short flags for the switch' do
        switch.short.each do |short|
          expect(switch.flags).to include(short)
        end
      end

      it 'contains all of the long flags for the switch' do
        switch.long.each do |long|
          expect(switch.flags).to include(long)
        end
      end
    end

    describe '#to_opt_parse' do
      let(:switch) {described_class.new(short: ['j', 'r'], long: ['jump', 'rock'], description: 'okay, I believe you')}

      it 'is an array' do
        expect(switch.to_opt_parse).to be_a(Array)
      end

      it 'has a specific order' do
        expected = switch.short.map {|short| "-#{short}"} + switch.long.map {|long| "--#{long}"} + [switch.description]
        expect(switch.to_opt_parse).to eql(expected)
      end
    end

  end
end
