require 'spec_helper'
require 'belafonte/helpers'

module Belafonte
  describe Helpers do
    it 'includes all of the helpers' do
      [
        Belafonte::Helpers::MetaData,
        Belafonte::Helpers::Arguments,
        Belafonte::Helpers::Flags,
        Belafonte::Helpers::Restricted,
        Belafonte::Helpers::Sharing,
        Belafonte::Helpers::Subcommands
      ].each do |mod|
        expect(described_class.included_modules).
          to include(mod)
      end
    end
  end
end
