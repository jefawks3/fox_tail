# frozen_string_literal: true

class FoxTail::TableComponent < FoxTail::BaseComponent
  renders_one :caption, lambda { |content_or_options = {}, options = {}, &block|
    if content_or_options.is_a? Hash
      options = content_or_options
      content_or_options = nil
    end

    content_or_options = capture(self, &block) if block
    options[:class] = classnames theme.apply(:caption, self), options[:class]
    content_tag :caption, content_or_options, options
  }

  renders_one :header, lambda { |options = {}|
    options = options.merge section_options
    options[:theme] = theme.theme :header
    FoxTail::Table::HeaderComponent.new options
  }

  renders_many :rows, lambda { |options = {}|
    options = options.merge section_options
    options[:theme] = theme.theme :row
    FoxTail::Table::RowComponent.new options
  }

  renders_one :footer, lambda { |options = {}|
    options = options.merge section_options
    options[:theme] = theme.theme :footer
    FoxTail::Table::RowComponent.new options
  }

  has_option :highlight, default: :none
  has_option :hover, type: :boolean, default: false
  has_option :border, type: :boolean, default: true

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  private

  def section_options
    self.options.slice :highlight, :hover, :border
  end
end
