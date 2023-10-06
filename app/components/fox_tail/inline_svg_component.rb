# frozen_string_literal: true

##
# Displays an SVG file inline
class FoxTail::InlineSvgComponent < FoxTail::BaseComponent
  attr_reader :path

  has_option :raise, as: :raise_error, type: :boolean

  def initialize(path, html_attributes = {})
    unless html_attributes.key? :raise
      html_attributes[:raise] = FoxTail::Base.fox_tail_config.raise_on_asset_not_found
    end

    super(html_attributes)

    @path = path.to_s
  end

  def call
    doc = Nokogiri::XML.parse asset_contents
    sanitized_html_attributes.each { |k, v| doc.child[k.to_s] = v }
    doc.child[:class] = html_class
    yield doc if block_given?
    doc.child.to_s.html_safe
  rescue FoxTail::AssetNotFound => e
    raise e if raise_error?

    Rails.logger.warn "[FoxTail::InlineSvgComponent] #{e.message}"
    content_tag :svg, nil, class: "hidden asset-not-found"
  end

  private

  def find_asset_path
    if (manifest_file = Rails.application.assets_manifest.assets[path])
      File.join(Rails.application.assets_manifest.directory, manifest_file)
    else
      Rails.application.assets.find_asset(path)&.filename
    end
  end

  def asset_contents
    asset_path = File.exist?(path) ? path : find_asset_path
    raise FoxTail::AssetNotFound.new(path) unless asset_path

    File.read(asset_path).force_encoding("UTF-8")
  end
end
