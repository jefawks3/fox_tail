# frozen_string_literal: true

class Flowbite::ListGroup::ItemComponent < Flowbite::ClickableComponent
  renders_one :visual, types: {
    icon: {
      as: :icon,
      renders: lambda { |icon, options = {}|
        options[:class] = classnames theme.apply(:visual, self), options[:class]
        Flowbite::IconBaseComponent.new icon, options
      }
    },
    svg: {
      as: :svg,
      renders: lambda { |path, options = {}|
        options[:class] = classnames theme.apply(:visual, self), options[:class]
        Flowbite::InlineSvgComponent.new path, options
      }
    },
    image: {
      as: :image,
      renders: lambda { |source, options = {}|
        options[:class] = classnames theme.apply(:visual, self), options[:class]
        image_tag source, options
      }
    }
  }

  renders_one :badge, lambda { |options = {}|
    options.reverse_merge! pill: true
    options[:class] = classnames theme.apply(:badge, self), options[:class]
    Flowbite::BadgeComponent.new options
  }

  has_option :static, type: :boolean, default: false
  has_option :flush, type: :boolean, default: false
  has_option :selected, type: :boolean, default: false

  def root_tag_name
    static? ? :div : super
  end

  def hoverable?
    !static?
  end

  def render?
    content?
  end

  def before_render
    super

    if selected?
      html_attributes[:aria] ||= {}
      html_attributes[:aria][:current] = true
    end
  end

  def call
    super do
      concat visual if visual?
      concat content
      concat badge if badge?
    end
  end
end
