require 'spec_helper'
require 'belafonte/help/app_extensions'

module Belafonte
  module Help
    describe AppExtensions do
      let(:simple) {Simple.new([]).extend(described_class)}
      let(:multi) {Multi.new([]).extend(described_class)}
      let(:unlimited) {Unlimited.new([]).extend(described_class)}
      let(:argumentative) {Argumentative.new([]).extend(described_class)}
      let(:mounter) {Mounter.new([]).extend(described_class)}
      let(:mounted) {
        mounter.instance_eval {
          subcommand_instance('mountable')
        }.extend(described_class)
      }

      let(:submounted) {
        mounted.instance_eval {
          subcommand_instance('submountable')
        }.extend(described_class)
      }

      describe '#root' do
        it 'is self for a root app' do
          expect(simple.root).to eql(simple)
          expect(mounter.root).to eql(mounter)
        end

        it 'is the top-most ancestor of a mounted app' do
          expect(mounted.root).to eql(mounter)
          expect(submounted.root).to eql(mounter)
        end
      end

      describe '#root?' do
        it 'is true if the app is the root' do
          expect(simple.root?).to eql(true)
          expect(mounter.root?).to eql(true)
        end

        it 'is false for a mounted app' do
          expect(mounted.root?).to eql(false)
          expect(submounted.root?).to eql(false)
        end
      end

      describe '#executable' do
        it 'is the CLI path basename used to run the app' do
          expect(simple.executable).to eql(File.basename($0))
        end
      end

      describe '#display_title' do
        it 'is the executable of a root app' do
          expect(simple.display_title).to eql(simple.executable)
        end

        it 'is the title of a non-root app' do
          expect(mounted.display_title).to eql(mounted.title)
        end
      end

      describe '#display_description' do
        it 'is a string' do
          expect(simple.display_description).to be_a(String)
        end

        it 'is the stringified description' do
          expect(simple.description).to receive(:to_s)

          simple.display_description
        end
      end

      describe '#command_arg' do
        context 'for an app with mounted commands' do
          context 'that is the Help subject' do
            before(:each) do
              Belafonte::Help::Generator.set_target(mounter)
            end

            it 'is "command" prepended with a space' do
              expect(mounter.command_arg).to eql(' command')
            end
          end

          context 'that is not the Help subject' do
            before(:each) do
              Belafonte::Help::Generator.set_target(submounted)
            end

            it 'is a blank string' do
              expect(mounted.command_arg).to eql('')
            end
          end
        end

        context 'for an app without mounted commands' do
          it 'is a blank string' do
            Belafonte::Help::Generator.set_target(simple)
            expect(simple.command_arg).to eql('')
          end
        end
      end

      describe '#signature' do
        it 'is a string' do
          expect(simple.signature).to be_a(String)
        end

        it 'contains the display title for the app' do
          expect(simple.signature).to match(/#{simple.display_title}/)
        end

        context 'for an app with args' do
          context '(single arg)' do
            it 'includes the arg' do
              expect(simple.signature).to match(/whatever/)
            end
          end

          context '(multi arg)' do
            it 'includes the arg' do
              expect(multi.signature).to match(/several/)
            end
          end

          context '(unlimited arg)' do
            it 'includes the arg' do
              expect(unlimited.signature).to match(/omgbigarg/)
            end
          end
        end
      end

      describe '#full_path' do
        context 'for a root app' do
          it 'is the app signature' do
            expect(simple.full_path).to eql(simple.signature)
          end
        end
 
        context 'for a mounted app' do
          it 'is the parent app full path and the mounted app signature' do
            expect(mounted.full_path).
              to eql("#{mounter.full_path} #{mounted.signature}")

            expect(submounted.full_path).
              to eql("#{mounted.full_path} #{submounted.signature}")
          end
        end
      end
    end
  end
end
