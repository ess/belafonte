require 'spec_helper'
require 'belafonte/app'

module Belafonte
  describe App do
    let(:argv) {["argv"]}
    let(:stdin) {Toady.new}
    let(:stdout) {Toady.new}
    let(:stderr) {Toady.new}
    let(:kernel) {Toady.new}
    
    describe '.new' do
      it 'requires argv' do
        expect{Simple.new}.to raise_error(ArgumentError)
        expect{Simple.new(argv)}.not_to raise_error
      end

      it 'has defaults for everything else' do
        simple = Simple.new(argv)
        expect(simple.stdin).to eql(STDIN)
        expect(simple.stdout).to eql(STDOUT)
        expect(simple.stderr).to eql(STDERR)
        expect(simple.kernel).to eql(Kernel)
      end
    end

    describe '.execute!' do
      it 'sets up the parser' do
        expect_any_instance_of(Simple).
          to receive(:setup_parser!).and_call_original

        Simple.new(argv).execute!
      end

      it 'processes argv' do
        expect_any_instance_of(Simple).
          to receive(:process_args!).and_call_original

        Simple.new(argv).execute!
      end
    end

    describe '.info' do
      it 'returns the provided metadata item' do
        described_class.meta[:day] = 'o'
        expect(described_class.info(:day)).to eql('o')
      end
    end

    describe '.mount' do
      it 'adds the provided App to subcommands' do
        expect(Simple.subcommands).to be_empty

        Simple.mount(Mountable)

        expect(Simple.subcommands).to eql([Mountable])
      end

      it 'raises an error when given itself to mount' do
        expect {Simple.mount(Simple)}.
          to raise_error(Belafonte::Errors::CircularMount)
      end
    end

    describe '.title' do
      it 'sets the title to the provided value' do
        expect(described_class.info(:title)).to be_nil
        described_class.title 'jump'
        expect(described_class.info(:title)).to eql('jump')
      end
    end

    describe '.summary' do
      it 'sets the summary to the provided value' do
        expect(described_class.info(:summary)).to be_nil
        described_class.summary 'in the line'
        expect(described_class.info(:summary)).to eql('in the line')
      end
    end

    describe '.description' do
      it 'sets the description to the provided value' do
        expect(described_class.info(:description)).to be_nil
        described_class.description 'Okay, I believe you'
        expect(described_class.info(:description)).to eql('Okay, I believe you')
      end
    end

    describe '.switches' do
      it 'is an array' do
        expect(described_class.switches).to be_a(Array)
      end

      it 'is the list of Switches that have been configured' do
        expect(described_class.switches).to be_empty
        described_class.switch :switch, short: 's'

        expect(described_class.switches).not_to be_empty
        described_class.switches.each do |switch|
          expect(switch).to be_a(Belafonte::Switch)
        end
      end
    end

    describe '.options' do
      it 'is an array' do
        expect(described_class.options).to be_a(Array)
      end

      it 'is the list of Options that have been configured' do
        expect(described_class.options).to be_empty
        described_class.option :option, short: 'o', argument: 'option'

        expect(described_class.options).not_to be_empty
        described_class.options.each do |option|
          expect(option).to be_a(Belafonte::Option)
        end
      end
    end

    describe '.args' do
      it 'is an array' do
        expect(described_class.args).to be_a(Array)
      end

      it 'is the list of Arguments that have been configured' do
        expect(described_class.args).to be_empty
        described_class.arg :argument

        expect(described_class.args).not_to be_empty
        described_class.args.each do |arg|
          expect(arg).to be_a(Belafonte::Argument)
        end
      end
    end

    describe '.arg' do
      it 'disallows arguments after an unlimited argument has been configured' do
        expect {
          described_class.class_eval do
            arg :argument
          end
        }.not_to raise_error

        expect {
          described_class.class_eval do
            arg :argument2, times: :unlimited
          end
        }.not_to raise_error

        expect {
          described_class.class_eval do
            arg :argument3
          end
        }.to raise_error(Belafonte::Errors::InvalidArgument)
      end
    end
  end
end
