# frozen_string_literal: true

require "fox_tail/config"

module FoxTail
  class Engine < Rails::Engine
    isolate_namespace FoxTail

    config.fox_tail = Config.defaults
    config.eager_load_paths = %W[#{root}/app/components #{root}/app/helpers]

    initializer "fox_tail.set_configs" do |app|
      ActiveSupport.on_load :fox_tail do
        Base.fox_tail_config = app.config.fox_tail
      end
    end

    rake_tasks do
      load File.join(__dir__, "tasks/fox_tail.rake")
    end
  end
end