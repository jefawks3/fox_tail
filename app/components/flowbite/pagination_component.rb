# frozen_string_literal: true

class Flowbite::PaginationComponent < Flowbite::BaseComponent
  attr_reader :url, :current_page, :total_pages

  renders_one :first_button, lambda { |options = {}|
    options[:action] = :first
    options[:size] = size
    options[:disabled] = first_page?
    options[:theme] = theme.theme :action
    options[:url] = page_url first_page
    Flowbite::Pagination::ActionComponent.new options
  }

  renders_one :previous_button, lambda { |options = {}|
    options[:action] = :previous
    options[:size] = size
    options[:disabled] = !previous_page?
    options[:theme] = theme.theme :action
    options[:url] = page_url previous_page
    Flowbite::Pagination::ActionComponent.new options
  }

  renders_one :next_button, lambda { |options = {}|
    options[:action] = :next
    options[:size] = size
    options[:disabled] = !next_page?
    options[:theme] = theme.theme :action
    options[:url] = page_url next_page
    Flowbite::Pagination::ActionComponent.new options
  }

  renders_one :last_button, lambda { |options = {}|
    options[:action] = :last
    options[:size] = size
    options[:disabled] = last_page?
    options[:theme] = theme.theme :action
    options[:url] = page_url last_page
    Flowbite::Pagination::ActionComponent.new options
  }

  has_option :first_page, default: 1
  has_option :page_key, default: :page
  has_option :url
  has_option :size, default: :base
  has_option :padding, default: 3
  has_option :variant, default: :text

  def initialize(current_page, total_pages, html_attributes = {})
    super(html_attributes)
    @current_page = current_page
    @total_pages = total_pages
  end

  def url
    return options[:url] if options.key? :url

    request.original_fullpath
  end

  def out_of_range?
    current_page >= first_page && current_page <= last_page
  end

  def first_page?
    current_page == first_page
  end

  def last_page
    total_pages - 1 + first_page
  end

  def last_page?
    current_page == last_page
  end

  def previous_page?
    current_page - 1 >= first_page
  end

  def previous_page
    current_page - 1 if previous_page?
  end

  def next_page?
    current_page + 1 <= last_page
  end

  def next_page
    current_page + 1 if next_page?
  end

  def display_range
    right_padding = current_page - [first_page, current_page - padding].max
    left_padding = [current_page + padding, last_page].min - current_page

    start_page = if right_padding <= left_padding
                   current_page - right_padding
                 else
                   [current_page - (right_padding + (padding - left_padding)), 1].max
                 end

    end_page = [last_page, start_page + (padding * 2)].min

    (start_page..end_page)
  end

  def left_page_gap?
    display_range.min > first_page
  end

  def right_page_gap?
    display_range.max != last_page
  end

  def page_url(page)
    uri = URI(url)
    query = ActiveSupport::HashWithIndifferentAccess.new Rack::Utils.parse_nested_query(uri.query)
    query[page_key] = page
    uri.query = Rack::Utils.build_nested_query query
    uri.to_s
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
    with_previous_button unless previous_button?
    with_next_button unless next_button?
  end
end
