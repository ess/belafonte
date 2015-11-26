require 'spec_helper'
require 'belafonte/senora'

module Belafonte
  describe Senora do
    before(:each) do
      described_class.data.clear
    end

    describe '.data' do
      it 'is a Hash' do
        expect(described_class.data).to be_a(Hash)
      end
    end

    describe '.store' do
      let(:key) {:key}
      let(:value) {'value'}

      it 'adds the given key and value to the data store' do
        expect(described_class.data.keys).not_to include(key)
        described_class.store(key, value)
        expect(described_class.data[key]).to eql(value)
      end

      it 'overwrites an existing value' do
        described_class.store(key, 1)
        expect(described_class.data[key]).to eql(1)
        
        described_class.store(key, 'one')
        expect(described_class.data[key]).to eql('one')
      end
    end

    describe '.retrieve' do
      let(:key) {:key}
      let(:value) {'gibberish'}

      it 'is nil for an unknown key' do
        expect(described_class.data.keys).not_to include(key)
        expect(described_class.retrieve(key)).to be_nil
      end

      it 'is the previously stored value for a known key' do
        described_class.store(key, value)
        expect(described_class.retrieve(key)).to eql(value)
      end
    end
  end
end
