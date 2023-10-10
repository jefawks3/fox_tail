# frozen_string_literal: true

class FoxTail::BaseComponent < FoxTail::Base
  include FoxTail::Concerns::HasTheme
  include FoxTail::Concerns::HasOptions

  attr_reader :html_attributes

  has_option :class, as: :html_class

  delegate :classname_merger, :use_stimulus?, :stimulus_merger, to: :class

  def initialize(html_attributes = {})
    super

    html_attributes = ActiveSupport::HashWithIndifferentAccess.new html_attributes
    theme = html_attributes.delete :theme
    self.theme.merge! theme if theme.present?
    extract_options! html_attributes
    @html_attributes = html_attributes
  end

  def with_html_attributes(attributes = {})
    @html_attributes.merge! attributes if attributes.present?
    self
  end

  def with_html_class(classes)
    options[:class] = classnames html_class, classes
    self
  end

  protected

  def classnames(*classnames)
    classname_merger.merge(*classnames)
  end

  def sanitized_html_attributes
    sanitize_attributes html_attributes
  end

  def sanitize_attributes(attributes)
    (attributes || {}).reject { |_, v| v.nil? }
  end

  class << self
    def classname_merger
      FoxTail::Base.fox_tail_config.classname_merger
    end

    def use_stimulus?
      !!FoxTail::Base.fox_tail_config.use_stimulus
    end

    def stimulus_merger
      FoxTail::Base.fox_tail_config.stimulus_merger
    end

    def override_files(extensions)
      # Taken from ViewComponent::Base.sidecar_files
      directory = override_directory
      filename = File.basename(source_location, ".rb")
      component_name = name.demodulize.underscore
      extensions = Array(extensions).join(",")

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
          Dir["#{directory}/#{filename}/#{component_name}.*{#{extensions}}"]
        else
          []
        end

      # view files in the same directory as the component
      sidecar_files = Dir["#{directory}/#{component_name}.*{#{extensions}}"]

      sidecar_directory_files = Dir["#{directory}/#{component_name}/#{filename}.*{#{extensions}}"]

      (sidecar_files - [source_location] + sidecar_directory_files + nested_component_files).uniq
    end

    def override_directory
      dir = FoxTail::Base.fox_tail_config.theme_path || ViewComponent::Base.config.view_component_path
      Rails.root.join dir, File.dirname(virtual_path).gsub(/^\/+/, "")
    end
  end
end
