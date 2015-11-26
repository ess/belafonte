require 'spec_helper'
require 'belafonte/flag'

module Belafonte
  describe Flag do
    describe '.shortify' do
      let(:item) {:whatever}
      let(:shortify) {described_class.shortify(item)}

      it 'is a string' do
        expect(shortify).to be_a(String)
      end

      it 'prepends the provided item with a hyphen' do
        expect(shortify).to eql("-#{item.to_s}")
      end
    end

    describe '.longify' do
      let(:item) {:something}
      let(:longify) {described_class.longify(item)}

      it 'is a string' do
        expect(longify).to be_a(String)
      end

      it 'prepends the provided item with two hyphens' do
        expect(longify).to eql("--#{item.to_s}")
      end
    end

    describe '.normalize_flag' do
      let(:flag) {'   d    a t         a       '}
      let(:normalized) {described_class.normalize_flag(flag)}

      it 'is a string' do
        expect(normalized).to be_a(String)
        expect(described_class.normalize_flag(:juniper)).to be_a(String)
      end

      it 'has no leading or trailing whitespace' do
        expect(normalized).not_to match(/^\s+\s+$/)
      end

      it 'has no leading or trailing hyphens' do
        expect(normalized).not_to match(/^-+.*-+$/)
      end

      it 'converts in-string whitespace to hyphens' do
        expect(normalized).not_to match(/\s+/)
        expect(normalized).to eql('d-a-t-a')
      end
    end

    describe '.new' do
      it 'requires a name' do
        expect {described_class.new(short: 'j')}.
          to raise_error(Belafonte::Errors::NoName, "Flag name cannot be blank")

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
        expect {described_class.new(name: :jump)}.to raise_error(Belafonte::Flag::NoFlags, "You must define at least one flag")
        expect {described_class.new(name: :jump, short: 'j')}.not_to raise_error
        expect {described_class.new(name: :jump, long: 'jump in the line')}.not_to raise_error
      end

      it 'stores its name as a symbol' do
        flag = described_class.new(name: 'string', short: 's')
        expect(flag.name.to_sym).to eql(flag.name)
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
