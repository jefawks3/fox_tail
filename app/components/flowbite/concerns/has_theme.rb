# frozen_string_literal: true

module Flowbite::Concerns::HasTheme
  extend ActiveSupport::Concern

  THEME_EXTENSION = "theme.yml"

  def with_theme(value = nil)
    theme.merge! block_given? ? yield(theme) : value
    self
  end

  protected

  def theme
    @theme ||= self.class.theme
  end

  class_methods do
    def theme(merge_base: true)
      theme = Flowbite::ViewComponents::Theme.new
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
      # Taken from ViewComponent::Base.sidecar_files
      directory = override_directory
      filename = File.basename(source_location, ".rb")
      component_name = name.demodulize.underscore

      # Add support for nested components defined in the same file.
      #
      # for example
      #
      # class MyComponent < ViewComponent::Base
      #   class MyOtherComponent < ViewComponent::Base
      #   end
      # end
      #
      # Without this, `MyOtherComponent` will not look for `my_component/my_other_component.html.erb`
      nested_component_files =
        if name.include?("::") && component_name != filename
          Dir["#{directory}/#{filename}/#{component_name}.*{#{THEME_EXTENSION}}"]
        else
          []
        end

      # view files in the same directory as the component
      sidecar_files = Dir["#{directory}/#{component_name}.*{#{THEME_EXTENSION}}"]

      sidecar_directory_files = Dir["#{directory}/#{component_name}/#{filename}.*{#{THEME_EXTENSION}}"]

      (sidecar_files - [source_location] + sidecar_directory_files + nested_component_files).uniq
    end

    def override_directory
      dir = Flowbite::ViewComponents::Base.flowbite_config.theme_path || ViewComponent::Base.config.view_component_path
      Rails.root.join dir, File.dirname(virtual_path).gsub(/^\/+/, "")
    end
  end
end
