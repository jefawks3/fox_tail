# frozen_string_literal: true

module Flowbite::ThemeHelper
  extend ActiveSupport::Concern

  protected

  def theme
    @theme ||= self.class.theme
  end

  class_methods do
    def theme(merge_base: true)
      theme = Flowbite::ViewComponents::Theme.new
      theme.merge! superclass.theme if merge_base && superclass.respond_to?(:theme)
      theme_file = component_theme_file
      theme.merge! theme_file if component_theme_file.present?
      theme
    end

    private

    def component_theme_file(extension = "theme.yml")
      sidecar_files([extension]).last # Prioritize the sub directory
    end
  end
end
