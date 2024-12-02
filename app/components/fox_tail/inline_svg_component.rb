# frozen_string_literal: true

##
# Displays an SVG file inline
class FoxTail::InlineSvgComponent < FoxTail::BaseComponent
  attr_reader :path

  has_option :raise, as: :raise_error, type: :boolean

  def initialize(path_or_html_attributes = {}, html_attributes = {})
    if path_or_html_attributes.is_a?(Hash)
      html_attributes = path_or_html_attributes
      path_or_html_attributes = nil
    end

    unless html_attributes.key? :raise
      html_attributes[:raise] = FoxTail::Base.fox_tail_config.raise_on_asset_not_found
    end

    super(html_attributes)

    @path = path_or_html_attributes&.to_s
  end

  def call
    doc = Nokogiri::XML.parse content? ? content : asset_contents
    node = doc.at_css "svg"
    node[:class] = html_class
    html_attributes.to_attributes.each { |k, v| node[k.to_s] = v if v.present? }
    yield node if block_given?
    node.to_s.html_safe # rubocop:disable Rails/OutputSafety
  rescue FoxTail::AssetNotFound => e
    raise e if raise_error?

    Rails.logger.warn "[FoxTail::InlineSvgComponent] #{e.message}"
    content_tag :svg, nil, class: "hidden asset-not-found"
  end

  private

  def find_asset_path
    find_by_application_asset_manifest || find_by_application_assets
  end

  def find_by_application_asset_manifest
    return unless Rails.application.respond_to?(:asset_manifest)

    manifest_file = Rails.application.assets_manifest.assets[path]
    return unless manifest_file

    File.join(Rails.application.assets_manifest.directory, manifest_file)
  end

  def find_by_application_assets
    return unless Rails.application.config.respond_to?(:assets)

    if Rails.application.config.assets.respond_to?(:resolve)
      Rails.application.config.assets.resolve(path)
    elsif Rails.application.config.assets.respond_to?(:find_asset)
      Rails.application.config.assets.find_asset(path)&.filename
    end
  end

  def asset_contents
    asset_path = File.exist?(path) ? path : find_asset_path
    raise FoxTail::AssetNotFound.new(path) unless asset_path

    File.read(asset_path).force_encoding("UTF-8")
  end
end
