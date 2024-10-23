# frozen_string_literal: true

module FoxTail::Concerns::Formable
  include ActionView::ModelNaming
  extend ActiveSupport::Concern

  FORM_OPTIONS = %i[
    object_name method_name namespace object
    skip_default_ids allow_method_names_outside_object
    value_array object_index
  ].freeze

  included do
    has_option :object_name
    has_option :method_name
    has_option :namespace
    has_option :object
    has_option :skip_default_ids, type: :boolean, default: false
    has_option :allow_method_names_outside_object, type: :boolean, default: false
    has_option :value_array, type: :boolean, default: false
    has_option :object_index
    has_option :errors_for
  end

  def initialize(*)
    super

    options[:object_name] = object_name.to_s.dup if object_name?
    options[:method_name] = method_name.to_s.dup if method_name?

    return unless object_name?

    object_name.sub!(/\[\]$/, "") || object_name.sub!(/\[\]\]$/, "]")

    if Regexp.last_match
      @generate_indexed_names = true
      @auto_index = retrieve_autoindex
    else
      @generate_indexed_names = false
      @auto_index = nil
    end
  end

  def name_and_id_index
    if options.key? :object_index
      object_index.presence || ""
    elsif @generate_indexed_names
      @auto_index || ""
    end
  end

  def value_from_object
    if @allow_method_names_outside_object
      object.public_send method_name if object.respond_to?(method_name)
    else
      object&.public_send method_name
    end
  end

  def value_came_from_user?
    method_came_from_user = "#{method_name}_came_from_user?"
    !object.respond_to?(method_came_from_user) || object.public_send(method_came_from_user)
  end

  def retrieve_autoindex
    unless object.respond_to?(:to_param)
      raise ArgumentError, <<~MSG
        object[] naming but object param and @object var don't exist or don't respond to to_param: #{object.inspect}
      MSG
    end

    object.to_param
  end

  def value_before_type_cast
    return if object.nil?

    method_before_type_cast = "#{method_name}_before_type_cast"

    if value_came_from_user? && object.respond_to?(method_before_type_cast)
      object.public_send(method_before_type_cast)
    else
      value_from_object
    end
  end

  def add_default_name_and_id_for_value(value, attributes: html_attributes)
    add_default_name attributes: attributes
    attributes[:id] = tag_id_for_value value, attributes: attributes unless attributes.key? :id
  end

  def tag_id_for_value(value, attributes = html_attributes)
    if value.nil?
      tag_id
    else
      specified_id = attributes[:id]
      id = tag_id

      if specified_id.blank? && id.present?
        "#{id}_#{sanitized_value(tag_value)}"
      else
        tag_id
      end
    end
  end

  def add_default_name_and_id(attributes: html_attributes)
    add_default_name attributes: attributes
    add_default_id attributes: attributes
  end

  def add_default_name(attributes: html_attributes)
    attributes[:name] = tag_name unless attributes.key? :name
  end

  def add_default_id(attributes: html_attributes)
    return if skip_default_ids?

    if attributes.key? :id
      attributes[:id] = attributes[:id] ? "#{namespace}_#{attributes[:id]}" : namespace if namespace?
    else
      attributes[:id] = tag_id
    end
  end

  def field_id(method, *suffixes, namespace: self.namespace, index: object_index)
    view_context.field_id(object_name, method, *suffixes, namespace: namespace.presence, index: index.presence).presence
  end

  def field_name(method, *methods, multiple: false, index: object_index)
    view_context.field_name(object_name, method, *methods, index: index.presence, multiple: !!multiple).presence
  end

  def tag_name
    field_name sanitized_method_name, multiple: value_array?, index: name_and_id_index
  end

  def tag_id
    field_id method_name, index: name_and_id_index, namespace: namespace
  end

  def sanitized_method_name
    @sanitized_method_name ||= method_name.presence&.delete_suffix("?")
  end

  def sanitized_value(value)
    value.to_s.gsub(/[\s.]/, "_").gsub(/[^-[[:word:]]]/, "").downcase
  end

  def translator(value: nil, scope: nil, default: "")
    FoxTail::Translator.new object, object_name, method_name, value: value, scope: scope, default: default
  end

  def object_errors_for
    (Array(method_name) + Array(options[:errors_for])).compact_blank.uniq
  end

  def object_errors?(methods = object_errors_for)
    return false if methods.blank?

    object = convert_to_model self.object
    return false if object.blank?

    methods.any? { |m| object.errors[m].present? }
  end

  def objectify_options(options)
    options.merge self.options.slice(*FORM_OPTIONS)
  end
end
