# frozen_string_literal: true

require "rails/generators"

module FoxTail
  class ThemesGenerator < Rails::Generators::Base
    desc "Copy Fox Tail UI component themes in your view component folder."

    source_root FoxTail.root.join("app/components/fox_tail").to_s

    class_option :components,
      aliases: "-c",
      type: :array,
      desc: "Select specific controllers to generate (i.e., Accordion, Modal, Tooltip, etc.)."

    def copy_themes
      if options.components.present?
        copy_selected_components
      else
        copy_all
      end
    end

    private

    def copy_selected_components
      options.components.each do |component|
        copy_theme_file "#{component.underscore}_component.theme.yml"
      end
    end

    def copy_all
      source_paths.each do |source_path|
        files = Dir[File.join(source_path, "**/*.theme.yml")]
        next if files.blank?

        files.each do |file|
          path = Pathname file
          path = path.relative_path_from source_path if path.absolute?
          copy_theme_file path.to_s
        end
      end
    end

    def copy_theme_file(file)
      copy_file file, File.join(ViewComponent::Base.view_component_path, "fox_tail", file)
    end
  end
end
