# frozen_string_literal: true

require "fox_tail/config"

module FoxTail
  class Engine < Rails::Engine
    isolate_namespace FoxTail

    config.fox_tail = Config.current
    config.eager_load_paths = %W[#{root}/app/components #{root}/app/helpers]

    initializer "fox_tail.tag_helper" do
      ActiveSupport.on_load(:action_view) do
        include FoxTail::TagHelper
      end
    end

    initializer "fox_tail.config.icon_sets" do |app|
      app.config.fox_tail.icon_sets[:hero] ||= FoxTail::IconSets::HeroIconSet
      app.config.fox_tail.icon_sets[:flowbite] ||= FoxTail::IconSets::FlowbiteIconSet
      app.config.fox_tail.default_icon_set ||= :hero
    end
  end
end
