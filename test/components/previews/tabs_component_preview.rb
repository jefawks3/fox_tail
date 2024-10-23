# frozen_string_literal: true

# @logical_path components
# @component FoxTail::TabsComponent
class TabsComponentPreview < ViewComponent::Preview
  def default
    render FoxTail::TabsComponent.new do |c|
      c.with_tab(selected: true).with_content "Profile"
      c.with_tab_content "Dashboard"
      c.with_tab_content "Settings"
      c.with_tab_content "Contacts"
      c.with_tab(disabled: true).with_content "Disabled"
    end
  end

  def underline
    render FoxTail::TabsComponent.new variant: :underline do |c|
      c.with_tab(selected: true).with_content "Profile"
      c.with_tab_content "Dashboard"
      c.with_tab_content "Settings"
      c.with_tab_content "Contacts"
      c.with_tab(disabled: true).with_content "Disabled"
    end
  end

  def visuals
    render FoxTail::TabsComponent.new variant: :underline do |c|
      c.with_tab(selected: true) do |t|
        t.with_left_icon "user-circle"
        "Profile"
      end
      c.with_tab do |t|
        t.with_left_icon "squares-2x2"
        "Dashboard"
      end
      c.with_tab do |t|
        t.with_left_icon "adjustments-vertical"
        "Settings"
      end
      c.with_tab do |t|
        t.with_left_icon "clipboard-document"
        "Contacts"
      end
      c.with_tab(disabled: true) do |t|
        "Disabled"
      end
    end
  end

  def pills
    render FoxTail::TabsComponent.new variant: :pills do |c|
      c.with_tab(selected: true).with_content "Profile"
      c.with_tab_content "Dashboard"
      c.with_tab_content "Settings"
      c.with_tab_content "Contacts"
      c.with_tab(disabled: true).with_content "Disabled"
    end
  end

  def full_width
    render FoxTail::TabsComponent.new variant: :full_width do |c|
      c.with_tab(selected: true, class: "rounded-l-lg").with_content "Profile"
      c.with_tab_content "Dashboard"
      c.with_tab_content "Settings"
      c.with_tab_content "Contacts"
      c.with_tab(disabled: true, class: "rounded-r-lg").with_content "Disabled"
    end
  end

  def controlled
    render FoxTail::TabsComponent.new variant: :underline, controlled: true do |c|
      c.with_tab(selected: true).with_content "Profile"
      c.with_tab_content "Dashboard"
      c.with_tab_content "Settings"
      c.with_tab_content "Contacts"
      c.with_tab(disabled: true).with_content "Disabled"
    end
  end

  def panels
    render FoxTail::TabsComponent.new id: :tabs_with_panels, variant: :underline, controlled: true do |c|
      c.with_tab(selected: true, panel_id: :profile).with_content "Profile"
      c.with_tab(panel_id: :dashboard).with_content("Dashboard")
      c.with_tab(panel_id: :settings).with_content("Settings")
      c.with_tab(panel_id: :contacts).with_content("Contacts")
      c.with_tab(disabled: true).with_content "Disabled"

      c.with_panel(:profile, open: true) do |p|
        p.content_tag :div, "Profile Data", class: "mt-2 p-4 rounded-lg bg-gray-50 dark:bg-gray-800 text-sm text-gray-500 dark:text-gray-400"
      end
      c.with_panel(:dashboard) do |p|
        p.content_tag :div, "Dashboard", class: "mt-2 p-4 rounded-lg bg-gray-50 dark:bg-gray-800 text-sm text-gray-500 dark:text-gray-400"
      end
      c.with_panel(:settings) do |p|
        p.content_tag :div, "Settings", class: "mt-2 p-4 rounded-lg bg-gray-50 dark:bg-gray-800 text-sm text-gray-500 dark:text-gray-400"
      end
      c.with_panel(:contacts) do |p|
        p.content_tag :div, "Contacts", class: "mt-2 p-4 rounded-lg bg-gray-50 dark:bg-gray-800 text-sm text-gray-500 dark:text-gray-400"
      end
    end
  end
end
