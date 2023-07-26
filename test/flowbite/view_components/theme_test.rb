require 'test_helper'
require 'flowbite/view_components/theme'

class Flowbite::ViewComponents::ThemeTest < ActiveSupport::TestCase
  def test_loads_yml_file
    theme = Flowbite::ViewComponents::Theme.load_file file_fixture("theme.yml").to_s
    assert_equal theme.classname("base"), "p-3 text-white"
  end

  def test_returns_classnames
    theme =  Flowbite::ViewComponents::Theme.new({
      "test" => "p-3 text-white",
      "container" => {
        "inline" => "mt-3"
      }
    })

    assert_equal theme.classname("test"), "p-3 text-white"
    assert_nil theme.classname("container")
    assert_equal theme.classname("container.inline"), "mt-3"
    assert_nil theme.classname("container.base")
    assert_equal theme.classname(%w[test]), "p-3 text-white"
    assert_nil theme.classname(%w[container])
    assert_equal theme.classname(%w[container inline]), "mt-3"
    assert_nil theme.classname(%w[container base])
    assert_equal theme["test"], "p-3 text-white"
    assert_nil theme["container"]
    assert_equal theme["container.inline"], "mt-3"
    assert_nil theme["container.base"]
    assert_equal theme[%w[test]], "p-3 text-white"
    assert_nil theme[%w[container]]
    assert_equal theme[%w[container inline]], "mt-3"
    assert_nil theme[%w[container base]]
  end

  def test_merges_with_file
    theme = Flowbite::ViewComponents::Theme.new "base" => "inline", "test" => "p-3 block"
    theme.merge! file_fixture("theme.yml").to_s
    assert_equal theme.classname("base"), "p-3 text-white"
    assert_equal theme.classname("test"), "p-3 block"
  end
end
