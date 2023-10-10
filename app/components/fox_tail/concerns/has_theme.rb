# frozen_string_literal: true

module FoxTail::Concerns::HasTheme
  extend ActiveSupport::Concern

  THEME_EXTENSION = "theme.yml"

  def theme
    @theme ||= self.class.theme
  end

  class_methods do
    def theme(merge_base: true)
      theme = FoxTail::Theme.new
      theme.merge! superclass.theme if merge_base && superclass.respond_to?(:theme)
      theme_files.each { |file| theme.merge! file }
      theme
    end

    private

    def theme_files
      (component_theme_files + custom_theme_files).uniq.select(&:present?)
    end

    def component_theme_files
      sidecar_files [THEME_EXTENSION]
    end

    def custom_theme_files
      override_files [THEME_EXTENSION]
    end
  end
end
