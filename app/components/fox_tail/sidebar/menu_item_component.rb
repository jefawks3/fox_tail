# frozen_string_literal: true

class FoxTail::Sidebar::MenuItemComponent < FoxTail::ClickableComponent
  renders_one :left_visual, types: {
    icon: {
      as: :left_icon,
      renders: lambda { |icon, options = {}|
        options[:class] = classnames theme.apply(:visual, self, {position: :left, type: :svg}),
          options[:class]

        FoxTail::IconBaseComponent.new icon, options
      }
    },
    svg: {
      as: :left_svg,
      renders: lambda { |path, options = {}|
        options[:class] = classnames theme.apply(:visual, self, {position: :left, type: :svg}),
          options[:class]

        FoxTail::InlineSvgComponent.new path, options
      }
    },
    image: {
      as: :left_image,
      renders: lambda { |source, options = {}|
        options[:class] = classnames theme.apply(:visual, self, {position: :left, type: :image}),
          options[:class]

        image_tag source, options
      }
    }
  }

  renders_one :right_visual, types: {
    icon: {
      as: :right_icon,
      renders: lambda { |icon, options = {}|
        options[:class] = classnames theme.apply(:visual, self, {position: :right, type: :icon}),
          options[:class]

        FoxTail::IconBaseComponent.new icon, options
      }
    },
    svg: {
      as: :right_svg,
      renders: lambda { |path, options = {}|
        options[:class] = classnames theme.apply(:visual, self, {position: :right, type: :svg}),
          options[:class]

        FoxTail::InlineSvgComponent.new path, options
      }
    },
    image: {
      as: :right_image,
      renders: lambda { |source, options = {}|
        options[:class] = classnames theme.apply(:visual, self, {position: :right, type: :image}),
          options[:class]
        image_tag source, options
      }
    },
    badge: {
      as: :badge,
      renders: lambda { |options = {}|
        options[:class] = classnames theme.apply(:visual, self, {position: :right, type: :badge}),
          options[:class]

        FoxTail::BadgeComponent.new options
      }
    }
  }

  renders_one :menu, lambda { |options = {}|
    options[:theme] = theme.theme :menu
    options[:id] = menu_id
    FoxTail::Sidebar::MenuComponent.new options
  }

  has_option :id
  has_option :menu_id
  has_option :selected, type: :boolean, default: false

  def initialize(html_attributes = {})
    super

    options[:id] ||= "menu_item_#{SecureRandom.alphanumeric 16}"
    options[:menu_id] ||= "#{options[:id]}_menu"
  end

  def link?
    menu? ? false : super
  end

  def before_render
    super

    if menu?
      with_right_icon "chevron-down" unless right_visual
    end
  end

  def call
    content_tag :li do
      if menu?
        concat render_collapsible_trigger
        concat render_menu
      else
        render_item
      end
    end
  end

  private

  def render_collapsible_trigger
    render FoxTail::CollapsibleTriggerComponent.new id, "##{menu_id}", open: selected?, theme: theme do |trigger|
      render_item trigger.html_attributes
    end
  end

  def render_item(attributes = {})
    attributes = stimulus_merger.merge_attributes html_attributes, attributes

    content_tag root_tag_name, attributes do
      concat left_visual if left_visual?
      concat content_tag(:span, content, class: theme.apply(:content, self))
      concat right_visual if right_visual?
    end
  end

  def render_menu
    render FoxTail::CollapsibleComponent.new(menu_id, open: selected?).with_content(menu)
  end
end
