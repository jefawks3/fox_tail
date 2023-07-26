# frozen_string_literal: true

##
# Displays an SVG file inline
# @param [String] path The full path or relative asset path to the SVG file
# @param [Hash] html_attributes The html attributes to apply to the SVG file
# @option html_attributes [Symbol] :size The size of the SVG image that is included in the theme
# @option html_attributes [Symbol] :color The color of the SVG image that is included in the theme
# @option html_attributes [Hash] :theme A hash object with the theme overrides
#
# Default options are:
#   :size => :md
#   :color => :current
class Flowbite::InlineSvgComponent < Flowbite::ViewComponents::Base
  attr_reader :path

  def initialize(path, html_attributes = {})
    @path = path.to_s
    super(html_attributes)
  end

  def call
    doc = Nokogiri::XML::DocumentFragment.parse asset_contents
    html_attributes.each { |k, v| doc.child[k.to_s] = v }
    yield doc if block_given?
    doc.to_s.html_safe
  end

  private

  def find_asset_path
    if (manifest_file = Rails.application.assets_manifest.assets[path])
      File.join(Rails.application.assets_manifest.directory, manifest_file)
    else
      Rails.application.assets&.[](path)&.filename
    end
  end

  def asset_contents
    asset_path = File.exist?(path) ? path : find_asset_path
    raise Flowbite::ViewComponents::AssetNotFound.new(path) unless asset_path

    File.read(asset_path).force_encoding("UTF-8")
  end
end
