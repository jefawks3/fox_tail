# frozen_string_literal: true

require 'test_helper'

class BaseTest < Minitest::Test
  def test_fox_tail_config_returns_default_config
    assert_instance_of FoxTail::Config, FoxTail::Base.fox_tail_config
  end
end
