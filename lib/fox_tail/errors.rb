# frozen_string_literal: true

module FoxTail
  class Error < StandardError; end

  class AssetNotFound < Error
    attr_reader :asset

    def initialize(asset, msg = "Could not find the asset \"#{asset}\"")
      super(msg)
      @asset = asset
    end
  end

  class ControllerNotImplemented < Error; end

  class ComponentError < Error
    attr_reader :component

    def initialize(component, msg = nil)
      @component = component
      super(msg)
    end
  end

  class ReservedOption < ComponentError
    attr_reader :option

    def initialize(component, option, msg = nil)
      @option = option
      msg ||= "#{component} declares an option \"#{option}\", which is a reserved word in the" \
        " FoxTail framework."

      super(component, msg)
    end
  end

  class ExtendThemeTypeMismatch < Error; end

  class InvalidIconSet < Error
    attr_reader :name

    def initialize(name, msg = nil)
      @name = name
      super(msg || "The icon set '#{name}' has not been registered. Make sure to add it to your FoxTail configuration.")
    end
  end

  class InvalidIconSetVariant < Error
    attr_reader :icon_set, :variant

    def initialize(icon_set, variant, msg = nil)
      @icon_set = icon_set
      @variant = variant
      super(msg || "Unknown variant #{variant} for #{icon_set} icon set.")
    end
  end
end
