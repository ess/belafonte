require 'spec_helper'
require 'belafonte/helpers/meta_data'

module Belafonte
  module Helpers
    describe MetaData do
      let(:dummy) {Object.new.extend(described_class)}

      describe '#title' do
        it 'gets the title from the class' do
          expect(dummy.class).
            to receive(:info).
            with(:title).
            and_return('totally tubular title')

          expect(dummy.title).to eql('totally tubular title')
        end
      end

      describe '#summary' do
        it 'gets the summary from the class' do
          expect(dummy.class).
            to receive(:info).
            with(:summary).
            and_return('super serious summary')

          expect(dummy.summary).to eql('super serious summary')
        end
      end

      describe '#description' do
        it 'gets the description from the class' do
          expect(dummy.class).
            to receive(:info).
            with(:description).
            and_return('silly description')

          expect(dummy.description).to eql('silly description')
        end
      end

      describe '#configured_switches' do
        it 'gets the switches configured in the class' do
          expect(dummy.class).
            to receive(:switches).
            and_return(['switch1'])

          expect(dummy.configured_switches).to eql(['switch1'])
        end
      end

      describe '#configured_options' do
        it 'gets the options configured in the class' do
          expect(dummy.class).
            to receive(:options).
            and_return(['option1'])

          expect(dummy.configured_options).to eql(['option1'])
        end
      end

      describe '#configured_args' do
        it 'gets the args configured in the class' do
          expect(dummy.class).
            to receive(:args).
            and_return(['arg1'])

          expect(dummy.configured_args).to eql(['arg1'])
        end
      end

      describe '#configured_subcommands' do
        it 'gets the subcommands configured in the class' do
          expect(dummy.class).
            to receive(:subcommands).
            and_return(['subcommand1'])

          expect(dummy.configured_subcommands).to eql(['subcommand1'])
        end
      end
    end
  end
end
