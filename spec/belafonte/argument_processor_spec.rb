require 'spec_helper'

module Belafonte
  describe ArgumentProcessor do
    describe '.new' do
      it 'processes the arguments' do
        expect_any_instance_of(described_class).to receive(:process).and_call_original

        described_class.new(argv: [], arguments: [])
      end

      it 'requires an argv array option' do
        expect{described_class.new(arguments: [])}.to raise_error(ArgumentError)
        expect{described_class.new(argv: [], arguments: [])}.not_to raise_error
      end

      it 'requires an arguments array option' do
        expect{described_class.new(argv: [])}.to raise_error(ArgumentError)
        expect{described_class.new(argv: [], arguments: [])}.not_to raise_error
      end

      it 'raises an error if too many args are provided' do
        expect {described_class.new(argv: [1], arguments: [])}.
          to raise_error(
            Belafonte::Errors::TooManyArguments,
            "More args provided than I can handle"
          )
      end
    end

    describe '#processed' do
      let(:arg_1) {Belafonte::Argument.new(name: :arg_1, times: 1)}
      let(:arg_2) {Belafonte::Argument.new(name: :arg_2, times: 2)}
      let(:arg_3) {Belafonte::Argument.new(name: :arg_3, times: :unlimited)}
      let(:args) {[arg_1, arg_2, arg_3]}
      let(:argv) {['work', 'senora', 'work your body line']}
      let(:processor) {
        described_class.new(argv: argv, arguments: args)
      }
      let(:processed) {processor.processed}

      it 'is a Hash' do
        expect(processed).to be_a(Hash)
        puts "processed == '#{processed}'"
      end

      it 'contains an array for each of the processed arguments' do
        args.each do |arg|
          expect(processed[arg.name]).to be_a(Array)
        end
      end

      it 'provides an array with an empty string for empty unlimited args' do
        expect(processed[:arg_3]).to eql([""])
      end
    end
  end
end
