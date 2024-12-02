# frozen_string_literal: true

class FoxTail::Tabs::TabComponent < FoxTail::ClickableComponent
  include FoxTail::Concerns::Identifiable

  renders_one :left_visual, types: {
    icon: {
      as: :left_icon,
      renders: lambda { |icon, options = {}|
        options[:class] = classnames theme.apply(:visual, self, {position: :left}), options[:class]
        FoxTail::IconBaseComponent.new icon, options
      }
    },
    svg: {
      as: :left_svg,
      renders: lambda { |path, options = {}|
        options[:class] = classnames theme.apply(:visual, self, {position: :left}), options[:class]
        FoxTail::InlineSvgComponent.new path, options
      }
    },
    image: {
      as: :left_image,
      renders: lambda { |source, options = {}|
        options[:class] = classnames theme.apply(:visual, self, {position: :left}), options[:class]
        image_tag source, options
      }
    }
  }

  renders_one :right_visual, types: {
    icon: {
      as: :right_icon,
      renders: lambda { |icon, options = {}|
        options[:class] = classnames theme.apply(:visual, self, {position: :right}), options[:class]
        FoxTail::IconBaseComponent.new icon, options
      }
    },
    svg: {
      as: :right_svg,
      renders: lambda { |path, options = {}|
        options[:class] = classnames theme.apply(:visual, self, {position: :right}), options[:class]
        FoxTail::InlineSvgComponent.new path, options
      }
    },
    image: {
      as: :right_image,
      renders: lambda { |source, options = {}|
        options[:class] = classnames theme.apply(:visual, self, {position: :right}), options[:class]
        image_tag source, options
      }
    }
  }

  has_option :tabs_id
  has_option :variant, default: :default
  has_option :selected, type: :boolean, default: false
  has_option :panel_id

  stimulated_with [:fox_tail, :tab], as: :tab, if: :controlled? do |controller|
    controller.with_value :selected, selected?
    controller.with_class :active, active_classes
    controller.with_class :selected, selected_classes
    controller.with_outlet controller.identifier, "##{tabs_id} [data-controller~='fox_tail--tab']" if tabs_id?
    controller.with_outlet collapsible_controller.identifier, "##{panel_id}" if panel_id?
    controller.with_action :select
  end

  stimulated_with [:fox_tail, :collapsible], as: :collapsible, register: false

  def visuals?
    left_visual? || right_visual?
  end

  def before_render
    super

    html_attributes[:role] = :tab
    html_attributes[:aria] ||= {}
    html_attributes[:aria][:selected] = selected?
    html_attributes[:aria][:controls] = panel_id if panel_id?
  end

  def call
    super do
      concat left_visual if left_visual?
      concat content
      concat right_visual if right_visual?
    end
  end

  def stimulus_controller_options
    {
      selected: selected?,
      active_classes: active_classes,
      selected_classes: selected_classes,
      siblings: tabs_id? ? "##{tabs_id} [data-controller~='fox_tail--tab']" : nil,
      panel: panel_id? ? "##{panel_id}" : nil
    }
  end

  protected

  def root_classes
    super do
      selected_classes if selected?
    end
  end

  def selected_classes
    theme.apply("root/selected", self)
  end
end
