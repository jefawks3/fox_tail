# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class FoxTail::StimulusControllerTest < Minitest::Test
  def setup
    @controller = FoxTail::StimulusController.new :test_controller
  end

  def test_identifier
    assert_equal "test-controller", @controller.identifier
  end

  def test_to_s
    assert_equal "test-controller", @controller.to_s
  end

  def test_to_sym
    assert_equal :test_controller, @controller.to_sym
  end

  def test_config
    assert_instance_of FoxTail::Config, @controller.config
  end

  def test_attributes
    assert_equal({ data: { controller: "test-controller" } }, @controller.attributes)
  end

  def test_target_key
    assert_equal :test_controller_foo_bar_value, @controller.value_key(:foo_bar)
  end

  def test_raw_target_key
    assert_equal :"data-test-controller-foo-bar-value", @controller.value_key(:foo_bar, raw: true)
  end

  def test_outlet_key
    assert_equal :test_controller_foo_bar_outlet, @controller.outlet_key(:foo_bar)
  end

  def test_raw_outlet_key
    assert_equal :"data-test-controller-foo-bar-outlet", @controller.outlet_key(:foo_bar, raw: true)
  end

  def test_classes_key
    assert_equal :test_controller_foo_bar_class, @controller.classes_key(:foo_bar)
  end

  def test_raw_classes_key
    assert_equal :"data-test-controller-foo-bar-class", @controller.classes_key(:foo_bar, raw: true)
  end

  def test_action_click
    assert_equal "test-controller#fooBar", @controller.action("fooBar")
  end

  def test_action_event
    assert_equal "hover->test-controller#fooBar", @controller.action("fooBar", event: :hover)
  end

  def test_action_param_key
    assert_equal :test_controller_id_param, @controller.action_param_key(:id)
  end

  def test_action_param_raw_key
    assert_equal :"data-test-controller-id-param", @controller.action_param_key(:id, raw: true)
  end

  def test_event
    assert_equal "test-controller:foo-bar", @controller.event("foo-bar")
  end

  def test_build_actions
    actual = @controller.build_actions( { show: [:click, :focus], hide: [:blur] })
    assert_equal "test-controller#show focus->test-controller#show blur->test-controller#hide", actual
  end

  def test_merge
    attributes = { data: { controller: "foo-bar", foo_bar_some_value: true, action: "foo-bar#show" } }
    mock = Minitest::Mock.new
    mock.expect :merge_attributes!, {}, [attributes, { data: { controller: "test-controller" } }]

    FoxTail::Config.current.stub :stimulus_merger, mock do
      @controller.merge attributes
    end

    assert_mock mock
    refute_same attributes, @controller.merge(attributes)
  end

  def test_merge!
    attributes = { data: { controller: "foo-bar", foo_bar_some_value: true, action: "foo-bar#show" } }
    mock = Minitest::Mock.new
    mock.expect :merge_attributes!, {}, [attributes, { data: { controller: "test-controller" } }]

    FoxTail::Config.current.stub :stimulus_merger, mock do
      @controller.merge! attributes
    end

    assert_mock mock
    assert_same attributes, @controller.merge!(attributes)
  end
end
