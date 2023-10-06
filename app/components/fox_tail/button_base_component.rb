# frozen_string_literal: true

class FoxTail::ButtonBaseComponent < FoxTail::ClickableComponent
  include FoxTail::Concerns::Formable

  has_option :variant, default: :solid
  has_option :size, default: :base
  has_option :color, default: :default
  has_option :pill, default: false, type: :boolean
  has_option :formmethod, as: :form_method
  has_option :value

  def before_render
    super

    if value.is_a?(Symbol) && object_name? && method_name?
      html_attributes[:name] = field_name value
      html_attributes[:id] = field_id value
    end

    html_attributes[:value] = value if value?

    if form_method? && !/post|get/i.match?(form_method) && !html_attributes.key?(:name) && !html_attributes.key?(:value)
      html_attributes[:formmethod] = :post
      html_attributes[:name] = "_method"
      html_attributes[:value] = form_method
    end
  end

  protected

  def retrieve_content
    content? ? content : i18n_content
  end

  # Taken from action_view/helpers/form_helper.rb
  #   and modified for the component
  def i18n_content
    return nil unless object_name? && html_attributes[:type]&.to_sym == :submit

    object = convert_to_model self.object
    key    = object ? (object.persisted? ? :update : :create) : :submit

    model = if object.respond_to?(:model_name)
              object.model_name.human
            else
              object_name.to_s.humanize
            end

    defaults = []
    defaults << if object.respond_to?(:model_name) && object_name.to_s == model.downcase
                  :"helpers.submit.#{object.model_name.i18n_key}.#{key}"
                else
                  :"helpers.submit.#{object_name}.#{key}"
                end

    defaults << :"helpers.submit.#{key}"
    defaults << "#{key.to_s.humanize} #{model}"
    I18n.t defaults.shift, model: model, default: defaults
  end
end
