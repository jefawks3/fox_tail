# frozen_string_literal: true

class Flowbite::Table::HeaderComponent < Flowbite::BaseComponent
  renders_many :columns, lambda { |options = {}|
    options = options.merge self.options
    options[:theme] = theme.theme :column
    options[:tag] = :th
    options[:scope] = :col
    Flowbite::Table::ColumnComponent.new options
  }

  has_option :highlight, default: :none
  has_option :hover, type: :boolean, default: false
  has_option :border, type: :boolean, default: true

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def render?
    columns?
  end

  def call
    content_tag :tr, html_attributes do
      columns.each { |column| concat column }
    end
  end
end
