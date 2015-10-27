require 'spec_helper'
require 'belafonte/help/flag_extensions'

module Belafonte
  module Help
    describe FlagExtensions do
      let(:switch) {
        Switch.new(
          name: :switch,
          short: 's',
          long: 'switch',
          description: "hey, I'm a switch!"
        ).extend(described_class)
      }

      let(:option) {
        Option.new(
          name: :option,
          short: 'o',
          long: 'option',
          description: "I R OPTION",
          argument: "something"
        ).extend(described_class)
      }

      describe '#short_flags' do
        it 'is an array' do
          expect(switch.short_flags).to be_a(Array)
          expect(option.short_flags).to be_a(Array)
        end

        it 'contains the shortified form of short flag variants' do
          expect(switch.short_flags).
            to eql(switch.instance_eval {short.map {|s| shortify(s)}})

          expect(option.short_flags).
            to eql(option.instance_eval {short.map {|s| shortify(s)}})
        end
      end

      describe '#long_flags' do
        it 'is an array' do
          expect(switch.long_flags).to be_a(Array)
          expect(option.long_flags).to be_a(Array)
        end

        it 'contains the longified form of the long flag variants' do
          expect(switch.long_flags).
            to eql(switch.instance_eval {long.map {|l| longify(l)}})

          expect(option.long_flags).
            to eql(option.instance_eval {long.map {|l| longify(l)}})
        end
      end

      describe '#signature' do
        it 'is a string' do
          expect(switch.signature).to be_a(String)
          expect(option.signature).to be_a(String)
        end

        it 'contains the shortified variants, longified variants, and description' do
          expect(switch.signature).to eql("-s, --switch - hey, I'm a switch!")
          expect(option.signature).to eql("-o SOMETHING, --option=SOMETHING - I R OPTION")
        end
      end
    end
  end
end
