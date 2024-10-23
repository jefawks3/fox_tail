# frozen_string_literal: true

# @component FoxTail::AlertComponent
# @logical_path components
class AlertComponentPreview < ViewComponent::Preview
  # @param severity select { choices: [info,success,warning,danger,neutral] } "Alert severity"
  # @param show_icon toggle "Show the alert icon"
  # @param show_header toggle "Show the alert header"
  # @param show_buttons toggle "Show the alert button footer"
  # @param icon "Override the alert icon"
  # @param border select { choices: [none,basic,accent] } "Border type"
  # @param rounded toggle "Round the corners"
  # @param dismiss toggle "Show the dismiss icon"
  # @param remove toggle "Remove the alert after animations"
  def playground(severity: :info, show_icon: true, show_header: true, icon: nil, border: :basic, rounded: true, dismiss: true, show_buttons: true, remove: false)
    render(FoxTail::AlertComponent.new(severity: severity, border: border, rounded: rounded, remove: remove)) do |c|
      c.with_icon(icon: icon.presence) if show_icon
      c.with_dismiss_icon if dismiss
      c.with_header_content "This is a header to the alert" if show_header

      if show_buttons
        c.with_button do |btn|
          btn.with_left_icon "eye"
          "View More"
        end
        c.with_dismiss_button_content "Dismiss"
      end

      "More info about this alert goes here. This example text is going to run a bit longer so that you can see how spacing within an alert works with this kind of content."
    end
  end

  # @!group Severity

  def info
    render(FoxTail::AlertComponent.new(severity: :info).with_content("A simple info alert"))
  end

  def success
    render(FoxTail::AlertComponent.new(severity: :success).with_content("A simple success alert"))
  end

  def warning
    render(FoxTail::AlertComponent.new(severity: :warning).with_content("A simple warning alert"))
  end

  def error
    render(FoxTail::AlertComponent.new(severity: :danger).with_content("A simple error alert"))
  end

  def neutral
    render(FoxTail::AlertComponent.new(severity: :neutral).with_content("A simple alert"))
  end

  # @!endgroup

  # @!group With Icon

  # @label Info
  def info_with_icon
    render(FoxTail::AlertComponent.new(severity: :info)) do |c|
      c.with_icon
      "An info alert with an icon"
    end
  end

  # @label Success
  def success_with_icon
    render(FoxTail::AlertComponent.new(severity: :success)) do |c|
      c.with_icon
      "A success alert with an icon"
    end
  end

  # @label Warning
  def warning_with_icon
    render(FoxTail::AlertComponent.new(severity: :warning)) do |c|
      c.with_icon
      "A warning alert with an icon"
    end
  end

  # @label Error
  def danger_with_icon
    render(FoxTail::AlertComponent.new(severity: :danger)) do |c|
      c.with_icon
      "An error alert with an icon"
    end
  end

  # @label Neutral
  def neutral_with_icon
    render(FoxTail::AlertComponent.new(severity: :neutral)) do |c|
      c.with_icon
      "An alert with an icon"
    end
  end

  # @!endgroup

  # @!group Bordered

  # @label Info
  def info_bordered
    render(FoxTail::AlertComponent.new(severity: :info, border: true)) do |c|
      c.with_icon
      "An info alert with a border"
    end
  end

  # @label Success
  def success_bordered
    render(FoxTail::AlertComponent.new(severity: :success, border: true)) do |c|
      c.with_icon
      "A success alert with a border"
    end
  end

  # @label Warning
  def warning_bordered
    render(FoxTail::AlertComponent.new(severity: :warning, border: true)) do |c|
      c.with_icon
      "A warning alert with a border"
    end
  end

  # @label Error
  def danger_bordered
    render(FoxTail::AlertComponent.new(severity: :danger, border: true)) do |c|
      c.with_icon
      "An error alert with a border"
    end
  end

  # @label Neutral
  def neutral_bordered
    render(FoxTail::AlertComponent.new(severity: :neutral, border: true)) do |c|
      c.with_icon
      "An alert with a border"
    end
  end

  # @!endgroup

  # @!group Accent Border

  # @label Info
  def info_with_accent_border
    render(FoxTail::AlertComponent.new(severity: :info, border: :accent, rounded: false)) do |c|
      c.with_icon
      "An info alert with a border"
    end
  end

  # @label Success
  def success_with_accent_border
    render(FoxTail::AlertComponent.new(severity: :success, border: :accent, rounded: false)) do |c|
      c.with_icon
      "A success alert with a border"
    end
  end

  # @label Warning
  def warning_with_accent_border
    render(FoxTail::AlertComponent.new(severity: :warning, border: :accent, rounded: false)) do |c|
      c.with_icon
      "A warning alert with a border"
    end
  end

  # @label Error
  def danger_with_accent_border
    render(FoxTail::AlertComponent.new(severity: :danger, border: :accent, rounded: false)) do |c|
      c.with_icon
      "An error alert with a border"
    end
  end

  # @label Neutral
  def neutral_with_accent_border
    render(FoxTail::AlertComponent.new(severity: :neutral, border: :accent, rounded: false)) do |c|
      c.with_icon
      "An alert with a border"
    end
  end

  # @!endgroup

  # @!group Dismissing

  # @label Info
  def info_dismissing
    render(FoxTail::AlertComponent.new(severity: :info)) do |c|
      c.with_icon
      c.with_dismiss_icon
      "An info alert with an icon"
    end
  end

  # @label Success
  def success_dismissing
    render(FoxTail::AlertComponent.new(severity: :success)) do |c|
      c.with_icon
      c.with_dismiss_icon
      "A success alert with an icon"
    end
  end

  # @label Warning
  def warning_dismissing
    render(FoxTail::AlertComponent.new(severity: :warning)) do |c|
      c.with_icon
      c.with_dismiss_icon
      "A warning alert with an icon"
    end
  end

  # @label Error
  def danger_dismissing
    render(FoxTail::AlertComponent.new(severity: :danger)) do |c|
      c.with_icon
      c.with_dismiss_icon
      "An error alert with an icon"
    end
  end

  # @label Neutral
  def neutral_dismissing
    render(FoxTail::AlertComponent.new(severity: :neutral)) do |c|
      c.with_icon
      c.with_dismiss_icon
      "An alert with an icon"
    end
  end

  # @!endgroup

  # @!group Additional Context

  # @label Info
  def info_with_additional_context
    render(FoxTail::AlertComponent.new(severity: :info, border: true)) do |c|
      c.with_icon
      c.with_dismiss_icon
      c.with_header_content "This is an Info alert"
      c.with_button do |btn|
        btn.with_left_icon "eye"
        "View More"
      end
      c.with_dismiss_button_content "Dismiss"
      "More info about this info alert goes here. This example text is going to run a bit longer so that you can see how spacing within an alert works with this kind of content."
    end
  end

  # @label Success
  def success_with_additional_context
    render(FoxTail::AlertComponent.new(severity: :success, border: true)) do |c|
      c.with_icon
      c.with_dismiss_icon
      c.with_header_content "This is an Success alert"
      c.with_button do |btn|
        btn.with_left_icon "eye"
        "View More"
      end
      c.with_dismiss_button_content "Dismiss"
      "More info about this success alert goes here. This example text is going to run a bit longer so that you can see how spacing within an alert works with this kind of content."
    end
  end

  # @label Success
  def warning_with_additional_context
    render(FoxTail::AlertComponent.new(severity: :warning, border: true)) do |c|
      c.with_icon
      c.with_dismiss_icon
      c.with_header_content "This is an Warning alert"
      c.with_button do |btn|
        btn.with_left_icon "eye"
        "View More"
      end
      c.with_dismiss_button_content "Dismiss"
      "More info about this warning alert goes here. This example text is going to run a bit longer so that you can see how spacing within an alert works with this kind of content."
    end
  end

  # @label Success
  def danger_with_additional_context
    render(FoxTail::AlertComponent.new(severity: :danger, border: true)) do |c|
      c.with_icon
      c.with_dismiss_icon
      c.with_header_content "This is an Error alert"
      c.with_button do |btn|
        btn.with_left_icon "eye"
        "View More"
      end
      c.with_dismiss_button_content "Dismiss"
      "More info about this error alert goes here. This example text is going to run a bit longer so that you can see how spacing within an alert works with this kind of content."
    end
  end

  # @label Success
  def neutral_with_additional_context
    render(FoxTail::AlertComponent.new(severity: :neutral, border: true)) do |c|
      c.with_icon
      c.with_dismiss_icon
      c.with_header_content "This is an Neutral alert"
      c.with_button do |btn|
        btn.with_left_icon "eye"
        "View More"
      end
      c.with_dismiss_button_content "Dismiss"
      "More info about this alert goes here. This example text is going to run a bit longer so that you can see how spacing within an alert works with this kind of content."
    end
  end

  # @!endgroup

  # @!group Auto Close

  def default_delay
    render(FoxTail::AlertComponent.new(auto_close: true).with_content("A simple info alert"))
  end

  def custom_delay
    render(FoxTail::AlertComponent.new(auto_close: true, delay: 5000).with_content("A simple info alert"))
  end

  # @!endgroup
end
