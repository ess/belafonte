require 'spec_helper'
require 'belafonte/rhythm'

module Belafonte
  describe Rhythm do
    let(:argv) {[]}
    let(:stdin) {FakeIO.new}
    let(:stdout) {FakeIO.new}
    let(:stderr) {FakeIO.new}
    let(:kernel) {Toady.new}

    let(:dummy) {
      Simple.new(argv, stdin, stdout, stderr, kernel)
    }

    describe '#execute!' do
      it 'sets up a parser' do
        expect(Belafonte::Parser).
          to receive(:new).
          with(
            {
              switches: dummy.configured_switches,
              options: dummy.configured_options,
              commands: dummy.configured_subcommands,
              arguments: dummy.configured_args,
              argv: dummy.argv
            }
          ).
          and_call_original

        dummy.execute!
      end

      it 'tries to run #setup' do
        expect(dummy).to receive(:run_setup).and_call_original

        dummy.execute!
      end

      it 'tries to dispatch to a subcommand' do
        expect(dummy).to receive(:dispatch).and_call_original

        dummy.execute!
      end

      context 'when dispatch is successful' do
        before(:each) do
          allow(dummy).to receive(:dispatch).and_return(true)
        end

        it 'does not show help' do
          expect(dummy).not_to receive(:show_help)

          dummy.execute!
        end

        it 'does not try handle the run' do
          expect(dummy).not_to receive(:run_handle)

          dummy.execute!
        end

        it 'returns 0' do
          expect(dummy.execute!).to eql(0)
        end
      end

      context 'when dispatch is not successful' do
        before(:each) do
          allow(dummy).to receive(:dispatch).and_return(false)
        end

        it 'tries to show help' do
          expect(dummy).to receive(:show_help).and_call_original

          dummy.execute!
        end

        context 'when help gets shown' do
          before(:each) do
            allow(dummy).to receive(:show_help).and_return(true)
          end

          it 'does not try to handle the run' do
            expect(dummy).not_to receive(:run_handle)

            dummy.execute!
          end
          
          it 'returns 0' do
            expect(dummy.execute!).to eql(0)
          end
        end

        context 'when it is not appropriate to show help' do
          before(:each) do
            allow(dummy).to receive(:show_help).and_return(false)
          end

          it 'tries to handle the run itself' do
            expect(dummy).to receive(:run_handle).and_call_original

            dummy.execute!
          end

          context 'when handled successfully' do
            before(:each) do
              allow(dummy).to receive(:run_handle).and_return(true)
            end

            it 'returns 0' do
              expect(dummy.execute!).to eql(0)
            end
          end
        end
      end

      context 'when the command lien cannot be handled by the app' do
        before(:each) do
          allow(dummy).to receive(:dispatch).and_return(false)
          allow(dummy).to receive(:show_help).and_return(false)
          allow(dummy).to receive(:run_handle).and_return(false)
        end

        it 'writes an error to stderr' do
          expect(stderr.length).to eql(0)
          dummy.execute!
          expect(stderr.length).not_to eql(0)
        end

        it 'returns 1' do
          expect(dummy.execute!).to eql(1)
        end
      end

      context 'when too many arguments are given' do
        let(:dummy) {
          Simple.new(['superfluous', 'args'], stdin, stdout, stderr, kernel)
        }

        it 'activates help' do
          expect(dummy.instance_eval {help_active?}).to eql(false)

          dummy.execute!

          expect(dummy.instance_eval {help_active?}).to eql(true)
        end
      end

      context 'when an otherwise uncaught exception is raised' do
        let(:broken) {
          Broken.new(argv, stdin, stdout, stderr, kernel)
        }

        it 'writes the error to stderr' do
          expect(stderr.length).to eql(0)
          broken.execute!
          expect(stderr.to_s).to match(/This is why we can't have nice things/)
        end

        it 'returns 255' do
          expect(broken.execute!).to eql(255)
        end
      end
    end
  end
end
