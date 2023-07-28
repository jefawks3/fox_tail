# frozen_string_literal: true

class Flowbite::BaseComponent < Flowbite::ViewComponents::Base
  include Flowbite::ThemeHelper

  def initialize(html_attributes = {})
    super()
    theme.merge! html_attributes.delete(:theme) if html_attributes[:theme].present?
    @html_attributes = html_attributes
    @html_class = html_attributes.delete :class
  end

  protected

  attr_reader :html_attributes, :html_class

  def classnames(*classnames)
    valid_classnames = classnames.reject { |c| !c || c.blank? }
    classname_merger.merge valid_classnames.join(" ") if valid_classnames.present?
  end
end
