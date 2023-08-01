# frozen_string_literal: true

class Flowbite::AvatarStackComponent < Flowbite::BaseComponent
  renders_many :avatars, lambda { |options = {}|
    options[:size] = size
    options[:rounded] = rounded
    options[:border] = true
    options[:class] = classnames theme.classname("avatar.base"), options[:class]
    Flowbite::AvatarComponent.new(**options)
  }

  renders_one :counter, lambda { |text, options = {}|
    options.extract! :src, :icon
    url = options.delete :url
    options[:text] = text
    options[:size] = size
    options[:rounded] = rounded
    options[:border] = true
    options[:class] = classnames theme.classname("avatar.base"),
                                 theme.classname("counter.base"),
                                 options[:class]

    if url.present?
      link_to url, class: theme.classname("counter.link") do
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

  def call
    root_classes = classnames theme.classname("root.base"), theme.classname([:root, :size, size]), html_class

    content_tag :div, html_attributes.merge(class: root_classes) do
      avatars.each { |avatar| concat avatar }
      concat counter if counter?
    end
  end
end
