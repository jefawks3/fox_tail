# frozen_string_literal: true

require "fox_tail/config"

module FoxTail
  class Engine < Rails::Engine
    isolate_namespace FoxTail

    config.fox_tail = Config.current
    config.eager_load_paths = %W[#{root}/app/components #{root}/app/helpers]
  end
end