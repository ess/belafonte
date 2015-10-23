require 'spec_helper'
require 'belafonte/helpers/arguments'

module Belafonte
  module Helpers
    describe Arguments do
      let(:dummy) {Object.new.extend(described_class)}

      describe '#args' do
        it 'is a hash' do
          expect(dummy.args).to be_a(Hash)
        end
      end

      describe '#arg' do
        before(:each) do
          dummy.args[:dummy] = 'dummy'
        end

        it 'is the value of a previously stored argument' do
          expect(dummy.arg(:dummy)).to eql('dummy')
        end

        it 'is nil if an unknown argument is requested' do
          expect(dummy.arg(:unknown)).to be_nil
        end
      end
    end
  end
end
