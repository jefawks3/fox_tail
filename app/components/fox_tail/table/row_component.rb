# frozen_string_literal: true

class FoxTail::Table::RowComponent < FoxTail::BaseComponent
  renders_many :columns, lambda { |options = {}|
    options = options.merge self.options
    options[:theme] = theme.theme :column
    options[:scope] ||= :row if options[:tag] == :th
    FoxTail::Table::ColumnComponent.new options
  }

  has_option :highlight, default: :none
  has_option :hover, type: :boolean, default: false
  has_option :border, type: :boolean, default: true

  def even?
    position.is_a?(Numeric) && position.even?
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag :tr, html_attributes do
      columns.each { |column| concat column }
    end
  end
end
