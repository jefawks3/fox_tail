# frozen_string_literal: true

class Flowbite::DropdownComponent < Flowbite::BaseComponent
  include Flowbite::Concerns::HasStimulusAndFlowbiteController

  attr_reader :id

  renders_one :trigger, types: {
    button: {
      renders: lambda { |icon: :chevron_down, **options|
        controller.merge! options, controller_options
        button = Flowbite::ButtonComponent.new(options)
        button.with_right_icon icon if icon.present?
        button
      },
      as: :button_trigger
    },
    icon: {
      renders: lambda { |icon, options = {}|
        controller.merge! options, controller_options
        Flowbite::IconButtonComponent.new icon, options
      },
      as: :icon_button_trigger
    },
    component: {
      renders: lambda { |tag_name: :button, **options, &block|
        controller.merge! options, controller_options
        content_tag tag_name, options, &block
      },
      as: :trigger
    }
  }

  renders_one :header, lambda { |options = {}, &block|
    content_tag :div, options.merge(class: classnames(theme.classname("header.base"), options[:class])), &block
  }

  renders_many :menus, Flowbite::Dropdown::MenuComponent

  has_option :divider, default: true, type: :boolean
  has_option :placement
  has_option :trigger_type
  has_option :offset_distance
  has_option :offset_skidding
  has_option :delay
  has_option :ignore_click_outside_class

  def initialize(id, html_attributes = {})
    @id = id
    super(html_attributes)
  end

  def call
    capture do
      concat trigger if trigger?
      concat render_dropdown
    end
  end

  def controller_options
    options.slice(*self.class.controller_option_keys).merge(dropdown_id: id)
  end

  private

  def render_dropdown
    root_classes = classnames theme.classname("root.base"),
                              divider? && theme.classname("root.divider"),
                              html_class

    content_tag :div, html_attributes.merge(id: id, class: root_classes) do
      concat header if header?
      menus.each { |menu| concat menu } if menus?
      concat content if content?
    end
  end

  def merge_trigger_attributes!(attributes)
    stimulus_merger.merge_attributes! attributes, trigger_attributes
  end

  class << self
    def controller_option_keys
      %i[placement trigger_type offset_skidding offset_distance delay ignore_click_outside_class]
    end
  end

  class StimulusController < Flowbite::ViewComponents::StimulusController
    def attributes(options = {})
      {
        data: {
          controller: identifier,
          value_key(:dropdown) => options[:dropdown_id],
          value_key(:placement) => options[:placement],
          value_key(:trigger_type) => options[:trigger_type],
          value_key(:offset_distance) => options[:offset_distance],
          value_key(:offset_skidding) => options[:offset_skidding],
          value_key(:delay) => options[:delay],
          value_key(:ignore_click_outside_class) => options[:ignore_click_outside_class]
        }
      }
    end
  end

  class FlowbiteController < Flowbite::ViewComponents::FlowbiteController
    def attributes(options = {})
      {
        data: {
          dropdown_toggle: options[:dropdown_id],
          dropdown_placement: options[:placement],
          dropdown_trigger_type: options[:trigger_type],
          dropdown_offset_distance: options[:offset_distance],
          dropdown_offset_skidding: options[:offset_distance],
          dropdown_delay: options[:delay],
          dropdown_ignore_click_outside_class: options[:ignore_click_outside_class]
        }
      }
    end
  end
end
