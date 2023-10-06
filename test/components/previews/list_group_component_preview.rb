# frozen_string_literal: true

# @logical_path components
# @component FoxTail::ListGroupComponent
class ListGroupComponentPreview < ViewComponent::Preview

  def default
    render FoxTail::ListGroupComponent.new class: "w-48" do |l|
      l.with_item(static: true).with_content "Profile"
      l.with_item(static: true).with_content "Settings"
      l.with_item(static: true).with_content "Messages"
      l.with_item(static: true).with_content "Download"
    end
  end

  def links
    render FoxTail::ListGroupComponent.new class: "w-48" do |l|
      l.with_item(url: "#", selected: true).with_content("Profile")
      l.with_item(url: "#").with_content("Settings")
      l.with_item(url: "#").with_content("Messages")
      l.with_item(url: "#", disabled: true).with_content("Download")
    end
  end

  def icons
    render FoxTail::ListGroupComponent.new class: "w-48" do |l|
      l.with_item(url: "#", selected: true) do |i|
        i.with_icon "user-circle"
        "Profile"
      end

      l.with_item(url: "#") do |i|
        i.with_icon "cog-6-tooth"
        "Settings"
      end

      l.with_item(url: "#") do |i|
        i.with_icon "bell"
        i.with_badge(color: :blue).with_content("3")
        "Messages"
      end

      l.with_item(url: "#", disabled: true) do |i|
        i.with_icon "arrow-down-tray"
        "Downloads"
      end
    end
  end
end
