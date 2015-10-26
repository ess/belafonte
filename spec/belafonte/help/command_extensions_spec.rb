require 'spec_helper'
require 'belafonte/help/command_extensions'

module Belafonte
  module Help
    describe CommandExtensions do
      let(:command) {Command.extend(described_class)}

      describe '#display_title' do
        it 'is the stringified title for the command' do
          expect(command.display_title).to eql(command.info(:title).to_s)
        end
      end

      describe '#display_summary' do
        it 'is the stringified summary for the command' do
          expect(command.display_summary).to eql(command.info(:summary).to_s)
        end
      end
    end
  end
end
