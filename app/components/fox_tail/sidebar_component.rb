# frozen_string_literal: true

class FoxTail::SidebarComponent < FoxTail::DrawerComponent
  renders_one :header

  renders_many :menus, lambda { |options = {}|
    options[:theme] = theme.theme :menu

    FoxTail::Sidebar::MenuComponent.new options
  }

  renders_one :divider, lambda { |options = {}|
    options[:class] = classnames theme.apply(:divider, self), options[:class]

    FoxTail::HrComponent.new options
  }

  has_option :dividers, type: :boolean, default: true

  def before_render
    super

    with_divider if !divider && dividers?
  end

  def call
    super do
      concat header if header?
      concat render_menus if menus?
    end
  end

  private

  def render_menus
    content_tag :div, class: theme.apply(:menu_container, self) do
      menus.each_with_index do |menu, index|
        concat divider if divider? && !index.zero?
        concat menu
      end
    end
  end

  class << self
    def stimulus_controller_name
      :drawer
    end
  end
end
