require 'spec_helper'
require 'belafonte/help'
require 'ostruct'

module Belafonte
  describe Help do
    describe '.content_for' do
      let(:app) {Simple.new([])}
      let(:generator) {OpenStruct.new(content: 'work, work, work')}

      it 'generates content for the app' do
        expect(Belafonte::Help::Generator).
          to receive(:new).
          with(app).
          and_return(generator)

        expect(described_class.content_for(app)).to eql(generator.content)
      end
    end
  end
end
