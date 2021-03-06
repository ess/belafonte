require 'spec_helper'
require 'belafonte/helpers/sharing'

module Belafonte
  module Helpers
    describe Sharing do
      let(:dummy) {Object.new.extend(described_class)}
      let(:key) {'key'}
      let(:value) {'value'}
      let(:storage) {Belafonte::Senora}

      before(:each) do
        storage.data.clear
      end

      describe '#share' do
        it 'stores the given key and value' do
          expect(storage).
            to receive(:store).
            with(key, value).
            and_call_original

          dummy.share(key, value)
        end
      end

      describe '#partake' do
        it 'retrieves the value for the given key' do
          expect(storage).
            to receive(:retrieve).
            with(key).
            and_call_original

          dummy.partake(key)
        end
      end
    end
  end
end
