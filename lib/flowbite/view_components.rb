require "active_support/dependencies/autoload"

require "flowbite/view_components/version"
require "flowbite/view_components/errors"
require "flowbite/view_components/engine"

module Flowbite
  module ViewComponents
    extend ActiveSupport::Autoload

    autoload :Config
    autoload :Base

    def self.root
      Pathname.new File.expand_path("../..", __dir__)
    end
  end
end
