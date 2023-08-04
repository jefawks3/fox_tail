# frozen_string_literal: true

class Flowbite::BaseComponent < Flowbite::ViewComponents::Base
  include Flowbite::Concerns::HasTheme
  include Flowbite::Concerns::HasOptions

  attr_reader :html_attributes, :html_class

  has_option :class, as: :html_class do |html_class, value|
    classnames html_class, value
  end

  def initialize(html_attributes = {})
    super()
    theme.merge! html_attributes.delete(:theme) if html_attributes[:theme].present?
    extract_options! html_attributes
    @html_attributes = html_attributes
  end

  def with_html_attributes(value = nil)
    attributes = block_given? ? yield : value
    @html_attributes.merge! attributes if attributes.present?
    self
  end

  protected

  def classnames(*classnames)
    valid_classnames = classnames.reject { |c| !c || c.blank? }
    classname_merger.merge valid_classnames.join(" ") if valid_classnames.present?
  end

  def classname_merger
    Flowbite::ViewComponents::Base.flowbite_config.classname_merger
  end
end
