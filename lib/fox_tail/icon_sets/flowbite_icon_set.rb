# frozen_string_literal: true

module FoxTail
  module IconSets
    class FlowbiteIconSet < Base
      ROOT_DIR = "app/assets/vendor/flowbite-icons"
      VARIANTS = %i[solid outline].freeze

      def path(icon, variant: :solid)
        __raise_invalid_variant(variant) unless VARIANTS.include?(variant.to_sym)

        file_name = "#{normalize_icon_name(icon)}.svg"
        root_path.join variant.to_s, file_name
      end

      def root_path
        FoxTail.root.join(ROOT_DIR)
      end
    end
  end
end
