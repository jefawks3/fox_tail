# frozen_string_literal: true

class FoxTail::FABComponent < FoxTail::BaseComponent
  include FoxTail::Concerns::Identifiable

  renders_many :items, lambda { |icon_or_options = {}, options = {}|
    if icon_or_options.is_a?(Hash)
      FoxTail::FAB::ItemComponent.new merge_item_options(icon_or_options)
    else
      FoxTail::FAB::ItemComponent.new icon_or_options, merge_item_options(options)
    end
  }

  renders_one :icon, lambda { |icon_or_options = {}, options = {}|
    if icon_or_options.is_a? Hash
      FoxTail::IconButtonComponent.new merge_fab_options(icon_or_options)
    else
      FoxTail::IconButtonComponent.new icon_or_options, merge_fab_options(options)
    end
  }

  has_option :placement, default: :bottom_right
  has_option :item_placement, default: :auto
  has_option :label_placement, default: :auto
  has_option :label_style, default: :tooltip
  has_option :rounded, type: :boolean, default: true
  has_option :trigger_type, default: :hover

  stimulated_with [:fox_tail, :fab], as: :fab do |controller|
    controller.with_value :trigger_type, trigger_type
    controller.with_class :visible, theme.apply("root/visible", self)
    controller.with_class :hidden, theme.apply("root/hidden", self)
  end

  def initialize(html_attributes = {})
    super

    generate_unique_id
    
    options[:item_placement] = calculate_item_placement if item_placement == :auto
    options[:label_placement] = calculate_label_placement if label_placement == :auto
  end

  def horizontal?
    !vertical?
  end

  def vertical?
    %i[top bottom].include? item_placement
  end

  def before_render
    super

    with_icon "plus" unless icon?

    html_attributes[:class] = classnames(
      theme.apply(:root, self),
      placement.is_a?(String) && placement,
      theme.apply("root/hidden", self),
      html_class
    )
  end

  def call
    content_tag :div, html_attributes do
      concat render_items if items? && render_items_first?
      concat icon
      concat render_items if items? && !render_items_first?
    end
  end

  private

  def merge_fab_options(options)
    options = options.merge variant: :solid, size: :fab, pill: rounded?
    options[:class] = classnames theme.apply(:visual, self), options[:class]
    options[:data] ||= {}
    options[:data][fab_controller.target_attribute_name] = :button
    options
  end

  def merge_item_options(options)
    options.merge(
      label_style: label_style,
      pill: rounded?,
      placement: placement,
      label_placement: label_placement,
      theme: theme.theme(:item)
    )
  end

  def calculate_item_placement
    placement.to_s.start_with?("top") ? :bottom : :top
  end

  def calculate_label_placement
    if vertical?
      placement.to_s.ends_with?("left") ? :right : :left
    else
      placement.to_s.start_with?("top") ? :bottom : :top
    end
  end

  def render_items_first?
    %i[top left].include? item_placement
  end

  def render_items
    attributes = {}
    attributes[:class] = classnames theme.apply(:menu, self)
    attributes[:data] = {}
    attributes[:data][fab_controller.target_attribute_name] = :menu

    content_tag :div, attributes do
      items.each { |item| concat item }
    end
  end
end
