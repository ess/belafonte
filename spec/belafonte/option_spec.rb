require 'spec_helper'
require 'belafonte/option'

module Belafonte
  describe Option do
    let(:arg) {'   f a  c    e     '}
    let(:normalized_arg) {'F_A_C_E'}
    let(:option) {described_class.new(name: :face, short: 'f', argument: arg)}

    it 'is a kind of Flag' do
      expect(described_class.new(name: :face, short: 'f', argument: 'face')).
        to be_a(Belafonte::Flag)
    end

    describe '.new' do
      it 'requires an argument name' do
        expect {described_class.new(name: :face, short: 'f')}.
          to raise_error(described_class::NoArgument, 'Option requires an argument name')

        expect {described_class.new(name: :face, short: 'f', argument: 'face')}.
          not_to raise_error
      end

      it 'normalizes the argument name' do
        actual_arg = option.instance_eval {@argument}

        expect(actual_arg).to eql(normalized_arg)
      end

      it 'allows a symbol as the argument name' do
        option = described_class.new(name: :face, short: 'f', argument: arg.to_sym)
        actual_arg = option.instance_eval {@argument}

        expect(actual_arg).to eql(normalized_arg)
      end
    end

    describe '#to_opt_parse' do
      let(:option) {
        described_class.new(
          name: :face,
          short: 'f',
          long: 'face',
          argument: 'face name'
        )
      }

      let(:to_opt_parse) {option.to_opt_parse}

      it 'contains the arg name with each flag' do
        expect(to_opt_parse[0]).to eql('-f FACE_NAME')
        expect(to_opt_parse[1]).to eql('--face=FACE_NAME')
      end
    end
  end
end
