require "test_helper"

class Flowbite::ViewComponents::MergerTest < ActiveSupport::TestCase
  def merger
    Flowbite::ViewComponents::Merger.new
  end

  def test_returns_nil_on_falsely
    classnames = merger.merge [false, nil, ""]
    assert_nil classnames
  end

  def test_merges_tailwind_classes
    classnames = merger.merge 'p-3 text-white dark:text-gray-900 p-8'
    assert_equal classnames, 'text-white dark:text-gray-900 p-8'
  end
end