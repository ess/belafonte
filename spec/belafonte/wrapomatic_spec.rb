require 'spec_helper'
require 'belafonte/wrapomatic'

module Belafonte
  describe Wrapomatic do
    let(:dummy) {Toady}
    let(:text) {"This is some text to wrap. It is intentionally long and contains a few newlines\nto ensure that all of the features of the wrapper\nwork\nas\nexpected."}

    it 'has readers for text, lines, indents, and columns' do
      described_class.new(text).tap do |wrapper|
        [:text, :lines, :indents, :columns].each do |method|
          expect(wrapper).to respond_to(method)
        end
      end
    end

    describe '.wrap' do
      it 'uses a new instance to wrap the provided text' do
        expect(described_class).
          to receive(:new).
          with(text, 0, 80).
          and_return(dummy)

        expect(dummy).to receive(:wrapped)

        described_class.wrap(text)
      end
    end

    describe '.new' do
      it 'has a default indentation level' do
        expect(described_class.new(text).indents).to eql(0)
        expect(described_class.new(text, 1).indents).to eql(1)
      end

      it 'has a default column cutoff' do
        expect(described_class.new(text).columns).to eql(80)
        expect(described_class.new(text, 0, 10).columns).to eql(10)
      end
    end

    describe '#lines' do
      let(:wrapper) {described_class.new(text)}
      let(:lines) {wrapper.lines}

      it 'is an array of strings' do
        expect(lines).to be_a(Array)
        lines.each do |line|
          expect(line).to be_a(String)
        end
      end

      it 'contains no line that is bigger than the cutoff' do
        lines.each do |line|
          expect(line.length > wrapper.columns).to eql(false)
        end
      end
    end

    describe '#wrapped' do
      let(:wrapper) {described_class.new(text)}
      let(:lines) {wrapper.lines}
      let(:wrapped) {wrapper.wrapped}

      it 'is lines joined by newlines' do
        expect(wrapped).to eql(lines.join("\n"))
      end
    end
  end
end
