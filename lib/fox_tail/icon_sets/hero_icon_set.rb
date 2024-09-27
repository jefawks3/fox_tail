# frozen_string_literal: true

module FoxTail
  module IconSets
    class HeroIconSet < Base
      ROOT_DIR = "app/assets/vendor/heroicons"
      VARIANTS = { solid: 24, outline: 24, micro: 20, mini: 16 }.freeze
      VARIANT_STYLES = { micro: :solid, mini: :solid }.freeze

      def path(icon, variant: :solid)
        variant = variant.to_sym
        __raise_invalid_variant(variant) unless VARIANTS.key?(variant)

        file_name = "#{normalize_icon_name(icon)}.svg"
        size = VARIANTS[variant].to_s
        style = VARIANT_STYLES.fetch(variant, variant).to_s

        root_path.join size, style, file_name
      end

      def root_path
        FoxTail.root.join(ROOT_DIR)
      end
    end
  end
end
