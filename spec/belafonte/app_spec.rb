require 'spec_helper'
require 'belafonte/app'

module Belafonte
  describe App do
    describe '.new'

    describe '.info'

    describe '.options' do
      it 'is an array' do
        expect(described_class.options).to be_a(Array)
      end

      it 'is the list of Options that have been configured' do
        expect(described_class.options).to be_empty
        described_class.class_eval do
          option :option, short: 'o', argument: 'option'
        end

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
        described_class.class_eval do
          arg :argument
        end
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
        }.to raise_error(Belafonte::Argument::Invalid)
      end
    end
  end
end
