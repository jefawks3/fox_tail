require "active_support/dependencies/autoload"

require "fox_tail/version"
require "fox_tail/errors"
require "fox_tail/engine"

module FoxTail
  extend ActiveSupport::Autoload

  autoload :ClassnameMerger
  autoload :Config
  autoload :Base
  autoload :Theme
  autoload :Translator
  autoload :StimulusController

  def self.root
    Pathname.new File.expand_path("..", __dir__)
  end

  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new("1.0", "FoxTail")
  end
end
