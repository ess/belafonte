require 'spec_helper'
require 'belafonte/helpers/flags'

module Belafonte
  module Helpers
    describe Flags do
      let(:dummy) {Object.new.extend(described_class)}

      describe '#switches' do
        it 'is a Hash' do
          expect(dummy.switches).to be_a(Hash)
        end
      end

      describe '#switch_active?' do
        before(:each) do
          dummy.switches[:day_o] = true
        end

        it 'is true if the switch has been activated' do
          expect(dummy.switch_active?(:day_o)).to eql(true)
        end

        it 'is nil if the switch has not been activated' do
          expect(dummy.switch_active?(:daylight_come)).to be_nil
        end
      end

      describe '#options' do
        it 'is a Hash' do
          expect(dummy.options).to be_a(Hash)
        end
      end

      describe '#option' do
        before(:each) do
          dummy.options[:six_foot] = 'seven foot'
        end

        it 'is the previously saved option' do
          expect(dummy.option(:six_foot)).to eql('seven foot')
        end

        it 'is nil for an unknown option' do
          expect(dummy.option(:eight_foot)).to be_nil
        end
      end
    end
  end
end
