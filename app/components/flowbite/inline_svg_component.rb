# frozen_string_literal: true

##
# Displays an SVG file inline
class Flowbite::InlineSvgComponent < Flowbite::BaseComponent
  attr_reader :path

  def initialize(path, html_attributes = {})
    @path = path.to_s
    super(html_attributes)
  end

  def call
    doc = Nokogiri::XML.parse asset_contents
    html_attributes.each { |k, v| doc.child[k.to_s] = v }
    doc.child[:class] = html_class
    yield doc if block_given?
    doc.child.to_s.html_safe
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
    raise Flowbite::ViewComponents::AssetNotFound.new(path) unless asset_path

    File.read(asset_path).force_encoding("UTF-8")
  end
end
