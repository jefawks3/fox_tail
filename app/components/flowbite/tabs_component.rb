# frozen_string_literal: true

class Flowbite::TabsComponent < Flowbite::BaseComponent
  has_option :variant, default: :default
  has_option :controlled, type: :boolean, default: false

  renders_many :tabs, lambda { |options = {}|
    options[:tabs_id] = tag_id
    options[:variant] = variant
    options[:controlled] = controlled?
    Flowbite::Tabs::TabComponent.new options
  }

  renders_many :panels, lambda { |id, options = {}|
    options[:role] = :tabpanel
    Flowbite::Tabs::PanelComponent.new id, options
  }

  def initialize(html_attributes = {})
    super(html_attributes)

    self.html_attributes[:id] ||= "tabs-#{SecureRandom.hex(4)}" if controlled?
  end

  def tag_id
    html_attributes[:id]
  end

  def render?
    tabs?
  end

  def before_render
    super

    html_attributes[:role] = :tablist
    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    capture do
      concat render_tabs
      concat render_panels if panels?
    end
  end

  private

  def render_tabs
    content_tag :div, html_attributes do
      tabs.each_with_index { |tab, index| concat render_tab(tab, index) }
    end
  end

  def render_panels
    content_tag :div do
      panels.each { |panel| concat panel }
    end
  end

  def tab_position(index)
    if index.zero?
      :start
    elsif index == tabs.length - 1
      :end
    else
      :middle
    end
  end

  def render_tab(tab, index)
    tab.with_html_class classnames(theme.apply(:tab, self, { position: tab_position(index) }), tab.html_class)
    tab
  end
end
