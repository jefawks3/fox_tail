# frozen_string_literal: true

class FoxTail::TabsComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Identifiable

  has_option :variant, default: :default
  has_option :controlled, type: :boolean, default: false

  renders_many :tabs, lambda { |options = {}|
    options[:tabs_id] = id
    options[:variant] = variant
    options[:controlled] = controlled?
    options[:theme] = theme.theme :tab
    FoxTail::Tabs::TabComponent.new options
  }

  renders_many :panels, lambda { |id, options = {}|
    options[:role] = :tabpanel
    FoxTail::Tabs::PanelComponent.new id, options
  }

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
      tabs.each { |tab| concat tab }
    end
  end

  def render_panels
    content_tag :div do
      panels.each { |panel| concat panel }
    end
  end
end
