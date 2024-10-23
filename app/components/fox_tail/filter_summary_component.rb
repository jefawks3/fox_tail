# frozen_string_literal: true

class FoxTail::FilterSummaryComponent < FoxTail::BaseComponent
  renders_many :filters, lambda { |name, options = {}|
    param_names << name.to_s
    filter_options = options.extract! :value
    dismiss_options = options.extract! :icon, :variant, :url
    dismiss_options[:url] ||= remove_filter_url(name, filter_options)
    options[:size] = size
    options[:color] ||= color

    FoxTail::WrapperComponent.new options do |wrapped|
      render FoxTail::BadgeComponent.new(wrapped.html_attributes) do |badge|
        badge.with_dismiss_icon(dismiss_options).with_content(t(".remove", default: "Remove"))
        wrapped.content
      end
    end
  }

  renders_one :clear_button, types: {
    button: {
      as: :clear_button,
      renders: lambda { |options = {}|
        options[:class] = classnames theme.apply(:clear_button, self), options[:class]
        options[:size] ||= :xs
        options[:url] ||= clear_url
        FoxTail::ButtonComponent.new options
      }
    },
    text: {
      as: :clear_link,
      renders: lambda { |options = {}|
        url = options.delete(:url) { clear_url }
        options[:class] = classnames theme.apply(:clear_text, self), options[:class]
        FoxTail::LinkComponent.new url, options
      }
    }
  }

  has_option :color, default: :default
  has_option :size, default: :base
  has_option :url
  has_option :params
  has_option :param_names, default: []

  def url
    options[:url] ||= request.original_fullpath
  end

  def render?
    filters?
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
  end

  def call
    content_tag :div, html_attributes do
      filters.each { |filter| concat filter }
      concat clear_button if clear_button?
    end
  end

  def clear_url
    uri = URI(url)
    params = Rack::Utils.parse_nested_query uri.query
    param_names.each { |name| params.delete name.to_s }
    uri.query = Rack::Utils.build_nested_query params
    uri.to_s
  end

  def remove_filter_url(name, options = {})
    uri = URI(url)
    params = Rack::Utils.parse_nested_query uri.query
    remove_filter params, name, options
    uri.query = Rack::Utils.build_nested_query params
    uri.to_s
  end

  def remove_filter(params, name, options = {})
    return params.delete(name.to_s) unless options.key? :value

    params[name.to_s]&.delete options[:value].to_s
  end
end
