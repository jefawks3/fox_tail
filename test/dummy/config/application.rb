require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require "fox_tail"

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
    config.eager_load_paths << FoxTail.root.join("app/components")

    config.assets.paths << FoxTail.root.join("test/dummy/app/assets")

    # I18n
    config.i18n.load_path += Dir[FoxTail.root.join("config/locales/*.yml")]

    # View Component
    config.view_component.view_component_path = FoxTail.root.join("app/components").to_s
    config.view_component.show_previews = true
    config.view_component.default_preview_layout = "component_preview"
    config.view_component.preview_paths = [
      FoxTail.root.join("test/components/previews")
    ]

    # Fox Tail Components
    config.fox_tail.theme_path = FoxTail.root.join("test/dummy/app/components").to_s
    # config.fox_tail.use_stimulus = false
    config.fox_tail.raise_on_asset_not_found = false

    # Lookbook
    config.lookbook.project_name = "FoxTail ViewComponents"
    config.lookbook.preview_display_options = {
      theme: ["light", "dark"]
    }

    config.lookbook.page_collection_label = "Docs"
  end
end
