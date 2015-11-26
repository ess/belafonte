require 'spec_helper'

module Belafonte
  describe Parser do
    let(:switches) {
      [
        Belafonte::Switch.new(name: :switch1, long: 'switch1'),
        Belafonte::Switch.new(name: :switch2, long: 'switch2')
      ]
    }

    let(:options) {
      [
        Belafonte::Option.new(name: :option1, long: 'option1', argument: 'option1'),
        Belafonte::Option.new(name: :option2, long: 'option2', argument: 'option2')
      ]
    }

    let(:arguments) {
      [
        Belafonte::Argument.new(name: :arg1),
        Belafonte::Argument.new(name: :arg2)
      ]
    }

    let(:parser) {described_class.new(switches: switches, options: options, arguments: arguments)}

    describe '.new' do
      it 'sets up the internals' do
        expect_any_instance_of(described_class).
          to receive(:setup).and_call_original

        described_class.new
      end

      it 'parses out options and switches' do
        expect_any_instance_of(described_class).
          to receive(:parse).and_call_original

        described_class.new
      end

      it 'adds a tail flag for help to the internal parser' do
        expect_any_instance_of(OptionParser).
          to receive(:on_tail).
          with('-h', '--help', 'Shows this message').
          and_call_original

        described_class.new
      end
    end

    describe '#parsed' do
      it 'has a switches hash' do
        expect(parser.parsed.fetch(:switches)).to be_a(Hash)
      end

      it 'has an options hash' do
        expect(parser.parsed.fetch(:options)).to be_a(Hash)
      end

      it 'has an args hash' do
        expect(parser.parsed.fetch(:args)).to be_a(Hash)
      end

      context 'when a defined switch is activated in argv' do
        let(:parser) {
          described_class.new(
            switches: switches,
            options: options,
            arguments: arguments,
            argv: ['--switch2']
          )
        }

        it 'has a parsed item for the switch' do
          expect(parser.parsed.fetch(:switches).fetch(:switch2)).to eql(true)
        end
      end

      context 'when a defined option is activated in argv' do
        let(:arg) {'option-argument'}

        let(:parser) {
          described_class.new(
            switches: switches,
            options: options,
            arguments: arguments,
            argv: ['--option2', arg]
          )
        }

        it 'has a parsed option with the proper value' do
          expect(parser.parsed.fetch(:options).fetch(:option2)).to eql(arg)
        end
      end

      context 'when the help flag is activated' do
        let(:parser) {
          described_class.new(
            switches: switches,
            options: options,
            arguments: arguments,
            argv: ['-h'])
        }

        it 'has an active :help item' do
          expect(parser.parsed.fetch(:help)).to eql(true)
        end
      end

      context 'when too many args are given' do
        let(:parser) {
          described_class.new(
            switches: switches,
            options: options,
            arguments: arguments,
            argv: ['one']
          )
        }

        it 'has an active :help item' do
          expect(parser.parsed.fetch(:help)).to eql(true)
        end
      end
    end

    describe '#parser' do
      it 'is an OptionParser' do
        expect(parser.parser).to be_a(OptionParser)
      end
    end
  end
end
