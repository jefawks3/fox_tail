# frozen_string_literal: true

class Flowbite::Dropdown::MenuItemComponent < Flowbite::ClickableComponent
  renders_one :left_icon, lambda { |icon, options = {}| render_icon icon, options, :start }
  renders_one :right_icon, lambda { |icon, options = {}| render_icon icon, options, :end }

  has_option :color, default: :default

  def visuals?
    left_icon? || right_icon?
  end

  def call
    super do
      concat left_icon if left_icon?
      concat content
      concat right_icon if right_icon?
    end
  end

  protected

  def root_classes
    classnames theme.classname("root.base"),
               theme.classname([:root, :color, color]),
               visuals? && theme.classname("root.visuals"),
               disabled? && theme.classname("root.disabled"),
               html_class
  end

  def disabled_classes
    classnames theme.classname("root.disabled")
  end

  def active_classes
    classnames theme.classname("root.base"),
               theme.classname([:root, :color, color]),
               visuals? && theme.classname("root.visuals"),
               html_class
  end

  private

  def render_icon(icon, options, side)
    options[:variant] ||= :mini
    options[:"aria-hidden"] = true
    options[:class] = classnames theme.classname("visuals.base"),
                                 theme.classname([:visuals, side]),
                                 options[:class]

    Flowbite::IconBaseComponent.new icon, **options
  end
end
