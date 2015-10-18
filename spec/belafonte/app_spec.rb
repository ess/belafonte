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
  end
end
