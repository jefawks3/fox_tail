# frozen_string_literal: true

require "test_helper"

class IconComponentTest < ViewComponent::TestCase
  def test_load_icon_from_string
    render_inline(FoxTail::IconComponent.new("arrow-right"))

    assert_selector "svg"
  end

  def test_load_icon_from_symbol
    render_inline(FoxTail::IconComponent.new(:arrow_right))

    assert_selector "svg"
  end

  def test_load_solid_arrow_right
    render_inline(FoxTail::IconComponent.new(:arrow_right, variant: :solid))

    assert_selector "svg"
  end

  def test_load_outline_arrow_right
    render_inline(FoxTail::IconComponent.new(:arrow_right, variant: :outline))

    assert_selector "svg"
  end

  def test_load_mini_arrow_right
    render_inline(FoxTail::IconComponent.new(:arrow_right, variant: :mini))

    assert_selector "svg"
  end

  def test_with_attributes
    render_inline(FoxTail::IconComponent.new(:arrow_right))

    assert_selector "svg"
  end
end
