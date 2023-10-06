require 'test_helper'

class FoxTail::ConfigTest < ActiveSupport::TestCase
  def test_defaults_are_correct
    config = FoxTail::Config.defaults
    assert_equal config.classname_merger.class, FoxTail::ClassnameMerger
  end
end
