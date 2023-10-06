# frozen_string_literal: true

class FoxTail::Pagination::ActionComponent < FoxTail::ClickableComponent
  renders_one :visual, types: {
    icon: {
      as: :icon,
      renders: lambda { |icon, options = {}|
        options[:class] = classnames theme.apply(:visual, self), options[:class]
        FoxTail::IconBaseComponent.new icon, options
      }
    },
    svg: {
      as: :svg,
      renders: lambda { |path, options = {}|
        options[:class] = classnames theme.apply(:visual, self), options[:class]
        FoxTail::InlineSvgComponent.new path, options
      }
    },
    image: {
      as: :image,
      renders: lambda { |source, options = {}|
        options[:class] = classnames theme.apply(:visual, self), options[:class]
        image_tag source, options
      }
    },
  }

  has_option :action
  has_option :size
  has_option :show_label, type: :boolean, default: true

  def left?
    %i[first previous].include? action
  end

  def right?
    !left?
  end

  def call
    super do
      concat visual if visual? && left?
      concat content_tag(:span, content || i18n_content, class: theme.apply(:label, self))
      concat visual if visual? && right?
    end
  end

  private

  def i18n_content
    I18n.t action, scope: "helpers.pagination", default: action.to_s.humanize
  end
end
