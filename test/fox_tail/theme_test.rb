require 'test_helper'
require 'minitest/autorun'
require 'fox_tail/theme'

class FoxTail::ThemeTest < ActiveSupport::TestCase
  def test_loads_yml_file
    assert_nothing_raised do
      FoxTail::Theme.load_file file_fixture("theme.yml").to_s
    end
  end

  def test_returns_classnames
    theme =  FoxTail::Theme.new({
      "test" => "p-3 text-white",
      "container" => {
        "inline" => "mt-3"
      }
    })

    assert_equal "p-3 text-white", theme.classname("test")
    assert_equal({ "inline" => "mt-3" }, theme.classname("container"))
    assert_equal "mt-3", theme.classname("container.inline")
    assert_nil theme.classname("container.base")
    assert_equal "p-3 text-white", theme.classname(%w[test])
    assert_equal({ "inline" => "mt-3" }, theme.classname(%w[container]))
    assert_equal "mt-3", theme.classname(%w[container inline])
    assert_nil theme.classname(%w[container base])
    assert_equal "p-3 text-white", theme["test"]
    assert_equal({ "inline" => "mt-3" }, theme["container"])
    assert_equal "mt-3", theme["container.inline"]
    assert_nil theme["container.base"]
    assert_equal "p-3 text-white", theme[%w[test]]
    assert_equal({ "inline" => "mt-3" }, theme[%w[container]])
    assert_equal "mt-3", theme[%w[container inline]]
    assert_nil theme[%w[container base]]
  end

  def test_merges_with_file
    theme = FoxTail::Theme.new({ "root" => { "base" => "inline" }, "test" => "p-3 block" })
    theme.merge! file_fixture("theme.yml").to_s
    assert_equal "p-3 text-white", theme.classname("root.base")
  end

  def test_apply
    theme = FoxTail::Theme.load_file file_fixture("theme.yml").to_s

    test_object = Struct.new("TestObject", :size, :rounded, :bottom, :variant) do
      def rounded?
        !!rounded
      end

      def bottom?
        !!bottom
      end
    end

    test_instance1 = test_object.new :sm, true, true, :default
    assert_equal "p-3 text-sm rounded border-b text-red-900 border-red-900", theme.apply(:root, test_instance1)
  end

  def test_return_sub_theme
    theme = FoxTail::Theme.load_file file_fixture("theme.yml").to_s
    actual = theme.theme :sub_theme
    expected = { "root" => { "base" => "p-4 sub-theme" } }
    assert_instance_of FoxTail::Theme, actual
    assert_equal expected, actual.send(:base_theme)
  end
end
