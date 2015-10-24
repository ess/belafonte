require 'spec_helper'
require 'belafonte/helpers/restricted'

module Belafonte
  module Helpers
    describe Restricted do
      let(:dummy) {Object.new.extend(described_class)}

      describe '#help' do
        it 'is not public' do
          expect {dummy.help}.to raise_error(NoMethodError)
          expect {dummy.instance_eval {help}}.not_to raise_error
        end

        it 'is false by default' do
          expect(dummy.instance_eval {help}).to eql(false)
        end

        it 'is an alias to the help instance variable' do
          dummy.instance_eval {@help = 'I need somebody'}

          expect(dummy.instance_eval {help}).to eql('I need somebody')
        end
      end

      describe '#activate_help!' do
        it 'is not public' do
          expect {dummy.activate_help!}.to raise_error(NoMethodError)

          expect {dummy.instance_eval {activate_help!}}.not_to raise_error
        end

        it 'makes help active' do
          expect(dummy.instance_eval {help}).to eql(false)
          
          dummy.instance_eval {activate_help!}

          expect(dummy.instance_eval {help}).to eql(true)
        end
      end

      describe '#help_active?' do
        it 'is not public' do
          expect {dummy.help_active?}.to raise_error(NoMethodError)

          expect {dummy.instance_eval {help_active?}}.not_to raise_error
        end

        it 'is an alias to #help' do
          expect(dummy).to receive(:help)

          dummy.instance_eval {help_active?}
        end
      end
    end
  end
end
