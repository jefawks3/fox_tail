# frozen_string_literal: true

# @logical_path components
# @component FoxTail::PaginationComponent
class PaginationComponentPreview < ViewComponent::Preview

  # @param page number
  # @param total number
  # @param size select { choices: [sm,base] }
  def playground(page: 6, total: 20, size: :base)
    render FoxTail::PaginationComponent.new(page.to_i, total.to_i, size: size)
  end

  # @!group Size

  def small(page: 6)
    render FoxTail::PaginationComponent.new(page.to_i, 20, size: :sm)
  end

  # @label Base (Default)
  def base(page: 6)
    render FoxTail::PaginationComponent.new(page.to_i, 20, size: :base)
  end

  # @!endgroup

  # @!group Actions

  def default_actions(page: 6)
    render FoxTail::PaginationComponent.new(page.to_i, 20)
  end

  def first_and_last_actions(page: 6)
    render FoxTail::PaginationComponent.new(page.to_i, 20) do |c|
      c.with_first_button
      c.with_last_button
    end
  end

  # @!endgroup

  # @!group Style

  def default_labels(page: 6)
    render FoxTail::PaginationComponent.new(page.to_i, 20) do |c|
      c.with_first_button
      c.with_previous_button
      c.with_next_button
      c.with_last_button
    end
  end

  def labels_and_icons(page: 6)
    render FoxTail::PaginationComponent.new(page.to_i, 20) do |c|
      c.with_first_button do |b|
        b.with_icon "chevron-double-left"
      end
      c.with_previous_button do |b|
        b.with_icon "chevron-left"
      end
      c.with_next_button do |b|
        b.with_icon "chevron-right"
      end
      c.with_last_button do |b|
        b.with_icon "chevron-double-right"
      end
    end
  end

  def icons_only(page: 6)
    render FoxTail::PaginationComponent.new(page.to_i, 20) do |c|
      c.with_first_button show_label: false do |b|
        b.with_icon "chevron-double-left"
      end
      c.with_previous_button show_label: false do |b|
        b.with_icon "chevron-left"
      end
      c.with_next_button show_label: false do |b|
        b.with_icon "chevron-right"
      end
      c.with_last_button show_label: false do |b|
        b.with_icon "chevron-double-right"
      end
    end
  end

  # @!endgroup
end
