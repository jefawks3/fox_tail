# frozen_string_literal: true

module FoxTail::Concerns::HasTheme
  extend ActiveSupport::Concern

  def theme
    @theme ||= self.class.theme
  end

  class_methods do
    def theme
      theme = FoxTail::Theme.new
      theme.merge! superclass.theme if superclass.respond_to?(:theme)
      theme_file = sidecar_files(["theme.yml"]).first
      theme.merge! theme_file if theme_file.present?
      theme
    end
  end
end
