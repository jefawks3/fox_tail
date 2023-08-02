require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require "flowbite/view_components"

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.eager_load_paths << Flowbite::ViewComponents.root.join("app/components")

    config.assets.paths << Flowbite::ViewComponents.root.join("test/dummy/app/assets")

    # View Component
    config.view_component.view_component_path = Flowbite::ViewComponents.root.join("app/components").to_s
    config.view_component.show_previews = true
    config.view_component.default_preview_layout = "component_preview"
    config.view_component.preview_paths = [
      Flowbite::ViewComponents.root.join("test/components/previews")
    ]

    # Flowbite Components
    config.flowbite_view_components.theme_path = Flowbite::ViewComponents.root.join("test/dummy/app/components").to_s
    # config.flowbite_view_components.use_stimulus = false

    # Lookbook
    config.lookbook.project_name = "Flowbite ViewComponents"
    config.lookbook.preview_display_options = {
      theme: ["light", "dark"]
    }
  end
end
