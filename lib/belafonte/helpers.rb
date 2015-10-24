require 'belafonte/helpers/meta_data'
require 'belafonte/helpers/sharing'
require 'belafonte/helpers/flags'
require 'belafonte/helpers/arguments'
require 'belafonte/helpers/subcommands'
require 'belafonte/helpers/restricted'

module Belafonte
  module Helpers
    include MetaData
    include Sharing
    include Flags
    include Arguments
    include Subcommands
    include Restricted
  end
end
