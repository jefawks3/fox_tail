require "test_helper"

class FoxTail::ClassnameMergerTest < ActiveSupport::TestCase
  attr_reader :merger

  def setup
    @merger = FoxTail::ClassnameMerger.new
  end

  def test_returns_nil_on_falsely
    classnames = merger.merge [false, nil, ""]
    assert_nil classnames
  end

  def test_merges_tailwind_classes
    classnames = merger.merge 'p-3 text-white dark:text-gray-900 p-8'
    assert_equal 'text-white dark:text-gray-900 p-8', classnames
  end
end