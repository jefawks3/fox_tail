# frozen_string_literal: true

require "test_helper"

class FoxTail::StimulusMergerTest < ActiveSupport::TestCase
  def setup
    @merger = FoxTail::StimulusMerger.new
  end

  def test_merge_actions
    assert_equal "foo-bar#show test-controller#hide", @merger.merge_actions("foo-bar#show", "test-controller#hide")
  end

  def test_merge_controllers
    assert_equal "foo-bar test-controller", @merger.merge_controllers("foo-bar", "test-controller")
  end

  def test_merge_attributes!
    attributes1 = {data: {controller: "foo-bar", foo_bar_value: true, action: "foo-bar#show"}}
    attributes2 = {data: {controller: "test", test_value: 3, test_foo_bar_class: "test", action: "test#hide"}}
    actual = @merger.merge_attributes! attributes1, attributes2

    assert_equal(
      {
        data: {
          controller: "foo-bar test",
          foo_bar_value: true,
          test_value: 3,
          test_foo_bar_class: "test",
          action: "foo-bar#show test#hide"
        }
      },
      actual
    )

    assert_same attributes1, actual
  end

  def test_merge_attributes
    attributes1 = {data: {controller: "foo-bar", foo_bar_value: true, action: "foo-bar#show"}}
    attributes2 = {data: {controller: "test", test_value: 3, test_foo_bar_class: "test", action: "test#hide"}}
    actual = @merger.merge_attributes attributes1, attributes2

    assert_equal(
      {
        data: {
          controller: "foo-bar test",
          foo_bar_value: true,
          test_value: 3,
          test_foo_bar_class: "test",
          action: "foo-bar#show test#hide"
        }
      },
      actual
    )

    assert_not_same attributes1, actual
  end
end
