# frozen_string_literal: true

require "fox_tail/config"

module FoxTail
  class Engine < Rails::Engine
    isolate_namespace FoxTail

    config.fox_tail = Config.current
    config.eager_load_paths = %W[#{root}/app/components #{root}/app/helpers]

    rake_tasks do
      load File.join(__dir__, "tasks/fox_tail.rake")
    end
  end
end