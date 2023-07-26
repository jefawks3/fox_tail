# frozen_string_literal: true

require 'view_component'
require 'flowbite/view_components/theme'

module Flowbite
  module ViewComponents
    class Base < ::ViewComponent::Base
      def initialize(html_attributes = {})
        super()
        @theme = self.class.theme.dup
        @theme.merge! html_attributes.delete(:theme) if html_attributes[:theme].present?
        @html_attributes = html_attributes
      end

      protected

      delegate :classname_merger, to: :class

      attr_reader :html_attributes, :theme

      def classnames(*classnames)
        valid_classnames = classnames.reject { |c| !c || c.blank? }
        classname_merger.merge valid_classnames.join(" ") if valid_classnames.present?
      end

      class << self
        delegate(*Flowbite::ViewComponents::Config.defaults.keys, to: :flowbite_config)

        def flowbite_config
          @flowbite_config ||= Flowbite::ViewComponents::Config.defaults
        end

        attr_writer :flowbite_config

        def theme
          theme = Flowbite::ViewComponents::Theme.new
          theme.merge! superclass.theme if superclass.respond_to? :theme
          theme_file = component_theme_file
          theme.merge! theme_file if component_theme_file.present?
          theme
        end

        private

        def component_theme_file(extension = "theme.yml")
          sidecar_files([extension]).last # Prioritize the sub directory
        end
      end

      ActiveSupport.run_load_hooks :flowbite_view_component, self
    end
  end
end
