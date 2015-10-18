require 'spec_helper'
require 'belafonte/argument'

module Belafonte
  describe Argument do
    describe '.new' do
      it 'requires a name' do
        expect {described_class.new}.
          to raise_error(Belafonte::Argument::NoName)

        expect {described_class.new(name: :jump)}.
          not_to raise_error
      end

      it 'is one occurrence by default' do
        argument = described_class.new(name: :jump)
        expect(argument.times).to eql(1)
      end

      it 'can have an unlimited number of occurrences' do
        argument = described_class.new(name: :jump, times: :unlimited)
        expect(argument.times).to eql(-1)
      end

      it 'can have an explicit number of occurrences' do
        argument = described_class.new(name: :jump, times: 2)
        expect(argument.times).to eql(2)
      end

      it 'requires that explicit occurrences be at least 1' do
        expect {described_class.new(name: :jump, times: 0)}.
          to raise_error(Belafonte::Argument::Invalid)
      end
    end

    describe '#process' do
      let(:argv) {["my", "girl's", "name", "is", "senora"]}

      context 'for an unlimited argument' do
        let(:argument) {described_class.new(name: :jump, times: :unlimited)}

        it 'is the entire argv passed in' do
          expect(argument.process(argv)).to eql(argv)
        end
      end

      context 'for a limited argument' do
        let(:jump1) {described_class.new(name: :jump)}
        let(:jump2) {described_class.new(name: :jump, times: 2)}
        let(:jump6) {described_class.new(name: :jump, times: 6)}

        it 'is the first "times" items from the provided argv' do
          expect(jump1.process(argv)).to eql(['my'])
          expect(jump2.process(argv)).to eql(["my", "girl's"])
        end

        it 'raises an error if there are not enough argv items' do
          expect {jump6.process(argv)}.
            to raise_error(Belafonte::Argument::NotEnoughData)
        end
      end
    end

    describe '#unlimited?' do
      it 'is false if the argument is limited' do
        expect(described_class.new(name: :jump).unlimited?).to eql(false)
      end

      it 'is true if the argument is unlimited' do
        expect(described_class.new(name: :jump, times: :unlimited).unlimited?).
          to eql(true)
      end
    end
  end
end