require 'spec_helper'
require 'belafonte/validator'

module Belafonte
  describe Validator do
    describe '#valid?' do
      context 'when the app lacks a title' do
        let(:validator) {described_class.new(Untitled)}
        let(:valid) {validator.valid?}

        it 'is false' do
          expect(valid).to eql(false)
        end

        it 'adds a "title" item to the errors' do
          expect(validator.errors.keys).not_to include(:title)
          valid
          expect(validator.errors.keys).to include(:title)
          expect(validator.errors[:title]).to eql("must be present")
        end
      end

      context 'for an app with exactly one unlimited argument' do
        let(:validator) {described_class.new(Unlimited)}
        let(:valid) {validator.valid?}

        it 'is true' do
          expect(valid).to eql(true)
        end
      end

      context 'for an app with more than one unlimited argument' do
        let(:validator) {described_class.new(Unlimitiception)}
        let(:valid) {validator.valid?}

        it 'is false' do
          expect(valid).to eql(false)
        end

        it 'adds an "args" item to the errors' do
          expect(validator.errors.keys).not_to include(:args)
          valid
          expect(validator.errors.keys).to include(:args)
          expect(validator.errors[:args]).
            to eql("cannot have more than one unlimited arg")
        end
      end

      context 'for an app with mounted apps but no unlimited args' do
        let(:validator) {described_class.new(Mounter)}
        let(:valid) {validator.valid?}

        it 'is true' do
          expect(valid).to eql(true)
        end
      end

      context 'for an app with unlimited args and mounted apps' do
        let(:validator) {described_class.new(UnlimitedCommand)}
        let(:valid) {validator.valid?}

        it 'is false' do
          expect(valid).to eql(false)
        end

        it 'adds a "mounts" item to the errors' do
          expect(validator.errors.keys).not_to include(:mounts)
          valid
          expect(validator.errors.keys).to include(:mounts)
          expect(validator.errors[:mounts]).
            to eql('cannot mount apps if you have unlimited args')
        end

        it 'adds an "args" item to the errors' do
          expect(validator.errors.keys).not_to include(:args)
          valid
          expect(validator.errors.keys).to include(:args)
          expect(validator.errors[:args]).
            to eql('cannot have unlimited args if you mount apps')
        end
      end

      context 'for a valid app' do
        let(:valid) {described_class.new(Simple).valid?}

        it 'is true' do
          expect(valid).to eql(true)
        end
      end
    end

    describe '#app_title' do
      let(:validator) {described_class.new(Simple)}

      it 'is the title of the app' do
        expect(validator.app_title).to eql(Simple.info(:title))
      end
    end
  end
end
