# frozen_string_literal: true

class FoxTail::IconBaseComponent < FoxTail::InlineSvgComponent
  attr_reader :name

  has_option :variant
  has_option :icon_set

  def variant
    options[:variant] ||= default_icon_variant
  end

  def initialize(name, html_attributes = {})
    @name = name.to_s.gsub("_", "-")
    super nil, html_attributes
  end

  def icon_set
    @icon_set ||= begin
                    name = options.fetch(:icon_set, default_icon_set).to_sym
                    icon_set = icon_sets.fetch name
                    raise FoxTail::InvalidIconSet.new(name) unless icon_set

                    icon_set.new name
                  end
  end

  def path
    @path ||= icon_set.path(name, variant: variant).to_s
  end

  private

  def icon_sets
    FoxTail::Base.fox_tail_config.icon_sets
  end

  def default_icon_set
    FoxTail::Base.fox_tail_config.default_icon_set
  end

  def default_icon_variant
    FoxTail::Base.fox_tail_config.default_icon_variant
  end
end
