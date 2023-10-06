# frozen_string_literal: true

class Flowbite::SpinnerComponent < Flowbite::InlineSvgComponent
  has_option :color, default: :default
  has_option :size, default: :base

  def initialize(html_attributes = {})
    path = html_attributes.delete(:path) { self.class.spinner_path }
    super path, html_attributes
  end

  def before_render
    super

    html_attributes[:"aria-hidden"] = true
    html_attributes[:role] = :status
  end

  def html_class
    classnames theme.apply(:root, self), super
  end

  class << self
    def spinner_path
      Flowbite::ViewComponents.root.join "app/assets/vendor/spinner.svg"
    end
  end
end
