require 'test_helper'

class Flowbite::ViewComponents::ConfigTest < ActiveSupport::TestCase
  def test_defaults_are_correct
    config = Flowbite::ViewComponents::Config.defaults
    assert_equal config.classname_merger.class, Flowbite::ViewComponents::Merger
  end
end
