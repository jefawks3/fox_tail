require "active_support/dependencies/autoload"

require "flowbite/view_components/version"
require "flowbite/view_components/errors"
require "flowbite/view_components/engine"

module Flowbite
  module ViewComponents
    extend ActiveSupport::Autoload

    autoload :ClassnameMerger
    autoload :Config
    autoload :Base
    autoload :Theme
    autoload :Controller
    autoload :StimulusController
    autoload :FlowbiteController

    def self.root
      Pathname.new File.expand_path("../..", __dir__)
    end
  end
end
