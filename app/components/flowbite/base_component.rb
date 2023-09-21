# frozen_string_literal: true

class Flowbite::BaseComponent < Flowbite::ViewComponents::Base
  include Flowbite::Concerns::HasTheme
  include Flowbite::Concerns::HasOptions

  attr_reader :html_attributes

  has_option :class, as: :html_class

  delegate :classname_merger, :use_stimulus?, :stimulus_merger, to: :class

  def initialize(html_attributes = {})
    super

    html_attributes = ActiveSupport::HashWithIndifferentAccess.new html_attributes
    theme.merge! html_attributes.delete(:theme) if html_attributes[:theme].present?
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
      Flowbite::ViewComponents::Base.flowbite_config.classname_merger
    end

    def use_stimulus?
      !!Flowbite::ViewComponents::Base.flowbite_config.use_stimulus
    end

    def stimulus_merger
      Flowbite::ViewComponents::Base.flowbite_config.stimulus_merger
    end

    def delayed_render(&block)
      lambda do |*args, &rblock|
        block.call *args, &rblock
      end
    end
  end

  class DelayRenderComponent < ViewComponent::Base
    def initialize(*, &block)
      super
      @block = block
    end

    def call
      block.call
    end
  end
end
