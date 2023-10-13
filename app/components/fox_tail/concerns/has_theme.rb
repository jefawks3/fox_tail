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
      theme.merge! theme_file if theme_file.present?
      theme
    end

    def theme_file
      theme_paths.detect(&:exist?)&.to_s
    end

    def theme_paths
      virtual_path = self.virtual_path.gsub %r{^/}, ""
      app_directory = Rails.root.join(ViewComponent::Base.view_component_path, File.dirname(virtual_path))
      directory = File.dirname(source_location)
      filename = File.basename(source_location, ".rb")
      component_name = name.demodulize.underscore

      sidecar_theme_files(app_directory, filename, component_name) +
        sidecar_theme_files(directory, filename, component_name)
    end

    private

    def sidecar_theme_files(directory, filename, component_name)
      directory = Pathname(directory) unless directory.is_a? Pathname

      files = [
        directory.join("#{component_name}.theme.yml"),          # Sidecar theme file
        directory.join(component_name, "#{filename}.theme.yml") # Sidecar directory file
      ]

      # Support nested components
      if name.include?("::") && component_name != filename
        files << directory.join(filename, "#{component_name}.theme.yml")
      end

      files
    end
  end
end
