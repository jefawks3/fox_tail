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
  end
end
