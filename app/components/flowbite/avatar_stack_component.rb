# frozen_string_literal: true

class Flowbite::AvatarStackComponent < Flowbite::BaseComponent
  renders_many :avatars, lambda { |options = {}|
    options[:size] = size
    options[:rounded] = rounded
    options[:border] = true unless options.key? :border
    options[:class] = classnames theme.apply(:content, self),
                                 theme.apply(:avatar, self),
                                 options[:class]

    Flowbite::AvatarComponent.new(**options)
  }

  renders_one :counter, lambda { |text, options = {}|
    options.extract! :src, :icon
    url = options.delete :url
    options[:text] = text
    options[:size] = size
    options[:rounded] = rounded
    options[:border] = true unless options.key? :border
    options[:class] = classnames theme.apply(:content, self),
                                 theme.apply(:counter, self),
                                 options[:class]

    if url.present?
      link_to url, class: theme.apply("counter/link", self) do
        render(Flowbite::AvatarComponent.new(**options))
      end
    else
      render(Flowbite::AvatarComponent.new(**options))
    end
  }

  has_option :size, default: :base
  has_option :rounded, default: true, type: :boolean

  def render?
    avatars? || counter?
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag :div, html_attributes do
      avatars.each { |avatar| concat avatar }
      concat counter if counter?
    end
  end
end
