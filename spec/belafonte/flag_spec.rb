require 'spec_helper'
require 'belafonte/flag'

module Belafonte
  describe Flag do
    describe '.new' do
      it 'requires a name' do
        expect {described_class.new(short: 'j')}.
          to raise_error(Belafonte::Errors::NoName)

        expect {described_class.new(name: :jump, short: 'j')}.
          not_to raise_error
      end

      it 'allows a single short name' do
        flag = described_class.new(name: :jump, short: 'j')
        expect(flag.short).to eql(['j'])
      end

      it 'allows an array of short names' do
        flag = described_class.new(name: :jump, short: ['j', 'r'])
        expect(flag.short).to eql(['j', 'r'])
      end

      it 'allows a single long name' do
        flag = described_class.new(name: :jump, long: 'jump in the line')
        expect(flag.long).to eql(['jump-in-the-line'])
      end

      it 'allows an array of long names' do
        flag = described_class.new(
          name: :jump,
          long: ['jump in the line', 'rock your body in time']
        )

        expect(flag.long).
          to eql(['jump-in-the-line', 'rock-your-body-in-time'])
      end

      it 'defaults the description to blank string' do
        flag = described_class.new(name: :jump, short: 'j')
        expect(flag.description).to eql('')

        flag = described_class.new(
          name: :jump,
          short: 'r',
          description: 'rocks your body'
        )

        expect(flag.description).to eql('rocks your body')
      end

      it 'requires that at least one short or one long flag be present' do
        expect {described_class.new(name: :jump)}.to raise_error(Belafonte::Flag::NoFlags)
        expect {described_class.new(name: :jump, short: 'j')}.not_to raise_error
        expect {described_class.new(name: :jump, long: 'jump in the line')}.not_to raise_error
      end
    end

    describe '#variations' do
      let(:flag) {
        described_class.new(
          name: :jump,
          short: ['j', 'r'],
          long: ['jump', 'rock'],
          description: 'okay, I believe you')
      }

      it 'is an array' do
        expect(flag.flags).to be_a(Array)
      end

      it 'contains all of the short variations of the flag' do
        flag.short.each do |short|
          expect(flag.flags).to include(short)
        end
      end

      it 'contains all of the long variations of the flag' do
        flag.long.each do |long|
          expect(flag.flags).to include(long)
        end
      end
    end

    describe '#to_opt_parse' do
      let(:flag) {
        described_class.new(
          name: :jump,
          short: ['j', 'r'],
          long: ['jump', 'rock'],
          description: 'okay, I believe you')
      }

      it 'is an array' do
        expect(flag.to_opt_parse).to be_a(Array)
      end

      it 'has a specific order' do
        expected = flag.short.map {|short| "-#{short}"} + flag.long.map {|long| "--#{long}"} + [flag.description]
        expect(flag.to_opt_parse).to eql(expected)
      end
    end

  end
end
