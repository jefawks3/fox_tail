# frozen_string_literal: true

require "flowbite/view_components/config"

module Flowbite
  module ViewComponents
    class Engine < Rails::Engine
      isolate_namespace Flowbite::ViewComponents

      config.flowbite_view_components = Flowbite::ViewComponents::Config.defaults
      config.eager_load_paths = %W[#{root}/app/components]

      initializer "flowbite_view_components.set_configs" do |app|
        ActiveSupport.on_load :view_component do
          ActiveSupport.on_load :flowbite_view_component do
            Flowbite::ViewComponents::Base.flowbite_config = app.config.flowbite_view_components
          end
        end
      end
    end
  end
end
