require 'spec_helper'
require 'belafonte/helpers/subcommands'

module Belafonte
  module Helpers
    describe Subcommands do
      let(:dummy) {Object.new.extend(described_class)}

      describe '#subcommands' do
        it 'is an array' do
          expect(dummy.subcommands).to be_a(Array)
        end
      end
    end
  end
end
