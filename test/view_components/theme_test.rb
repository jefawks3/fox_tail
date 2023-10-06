require 'test_helper'
require 'fox_tail/theme'

class FoxTail::ThemeTest < ActiveSupport::TestCase
  def test_loads_yml_file
    theme = FoxTail::Theme.load_file file_fixture("theme.yml").to_s
    assert_equal theme.classname("root._base"), "p-3 text-white"
  end

  def test_returns_classnames
    theme =  FoxTail::Theme.new({
      "test" => "p-3 text-white",
      "container" => {
        "inline" => "mt-3"
      }
    })

    assert_equal theme.classname("test"), "p-3 text-white"
    assert_equal theme.classname("container"), { "inline" => "mt-3" }
    assert_equal theme.classname("container.inline"), "mt-3"
    assert_nil theme.classname("container.base")
    assert_equal theme.classname(%w[test]), "p-3 text-white"
    assert_equal theme.classname(%w[container]), { "inline" => "mt-3" }
    assert_equal theme.classname(%w[container inline]), "mt-3"
    assert_nil theme.classname(%w[container base])
    assert_equal theme["test"], "p-3 text-white"
    assert_equal theme["container"], { "inline" => "mt-3" }
    assert_equal theme["container.inline"], "mt-3"
    assert_nil theme["container.base"]
    assert_equal theme[%w[test]], "p-3 text-white"
    assert_equal theme[%w[container]], { "inline" => "mt-3" }
    assert_equal theme[%w[container inline]], "mt-3"
    assert_nil theme[%w[container base]]
  end

  def test_merges_with_file
    theme = FoxTail::Theme.new({ "root" => { "_base" => "inline" }, "test" => "p-3 block" })
    theme.merge! file_fixture("theme.yml").to_s
    assert_equal theme.classname("root._base"), "p-3 text-white"
    assert_equal theme.classname("test"), "p-3 block"
  end

  def test_apply
    theme = FoxTail::Theme.load_file file_fixture("theme.yml").to_s

    test_object = Struct.new("TestObject", :size, :rounded, :bottom, :variant) do |new_class|
      def rounded?
        !!rounded
      end

      def bottom?
        !!bottom
      end
    end

    test_instance1 = test_object.new :sm, true, true, :default
    assert_equal theme.apply(:root, test_instance1), "p-3 text-sm rounded border-b text-red-900 border-red-900"
  end
end
