# frozen_string_literal: true

class BadgeComponentPreview < ViewComponent::Preview
  ICON = "check-circle"

  # @param text "The contents of the badge"
  # @param size select { choices: [base,sm] } "The size of the badge"
  # @param color "The theme color of the badge"
  # @param icon "The Heroicon to add to the badge"
  # @param pill toggle "Display the badge as a pill"
  # @param border toggle "Add a border to the badge"
  # @param url "Convert the badge to a link"
  def playground(size: :base, color: :default, icon: nil, pill: false, border: false, url: nil, text: "Badge")
    render(Flowbite::BadgeComponent.new(size: size, color: color, pill: pill, border: border, url: url)) do |c|
      c.with_icon icon if icon.present?
      text
    end
  end

  # @!group Theme

  # @label Neutral (Default)
  def neutral
    render(Flowbite::BadgeComponent.new(color: :neutral).with_content("Badge"))
  end

  def dark
    render(Flowbite::BadgeComponent.new(color: :dark).with_content("Badge"))
  end

  def light
    render(Flowbite::BadgeComponent.new(color: :light).with_content("Badge"))
  end

  def red
    render(Flowbite::BadgeComponent.new(color: :red).with_content("Badge"))
  end

  def blue
    render(Flowbite::BadgeComponent.new(color: :blue).with_content("Badge"))
  end

  def green
    render(Flowbite::BadgeComponent.new(color: :green).with_content("Badge"))
  end

  def yellow
    render(Flowbite::BadgeComponent.new(color: :yellow).with_content("Badge"))
  end

  def indigo
    render(Flowbite::BadgeComponent.new(color: :indigo).with_content("Badge"))
  end

  def purple
    render(Flowbite::BadgeComponent.new(color: :purple).with_content("Badge"))
  end

  def pink
    render(Flowbite::BadgeComponent.new(color: :pink).with_content("Badge"))
  end

  def info
    render(Flowbite::BadgeComponent.new(color: :info).with_content("Badge"))
  end

  def success
    render(Flowbite::BadgeComponent.new(color: :success).with_content("Badge"))
  end

  def warning
    render(Flowbite::BadgeComponent.new(color: :warning).with_content("Badge"))
  end

  def error
    render(Flowbite::BadgeComponent.new(color: :error).with_content("Badge"))
  end

  # @!endgroup

  # @!group Pill

  # @label Neutral (Default)
  def pill_neutral
    render(Flowbite::BadgeComponent.new(color: :neutral, pill: true).with_content("Badge"))
  end

  # @label Dark
  def pill_dark
    render(Flowbite::BadgeComponent.new(color: :dark, pill: true).with_content("Badge"))
  end

  # @label Light
  def pill_light
    render(Flowbite::BadgeComponent.new(color: :light, pill: true).with_content("Badge"))
  end

  # @label Red
  def pill_red
    render(Flowbite::BadgeComponent.new(color: :red, pill: true).with_content("Badge"))
  end

  # @label Blue
  def pill_blue
    render(Flowbite::BadgeComponent.new(color: :blue, pill: true).with_content("Badge"))
  end

  # @label Green
  def pill_green
    render(Flowbite::BadgeComponent.new(color: :green, pill: true).with_content("Badge"))
  end

  # @label Yellow
  def pill_yellow
    render(Flowbite::BadgeComponent.new(color: :yellow, pill: true).with_content("Badge"))
  end

  # @label Indigo
  def pill_indigo
    render(Flowbite::BadgeComponent.new(color: :indigo, pill: true).with_content("Badge"))
  end

  # @label Purple
  def pill_purple
    render(Flowbite::BadgeComponent.new(color: :purple, pill: true).with_content("Badge"))
  end

  # @label Pink
  def pill_pink
    render(Flowbite::BadgeComponent.new(color: :pink, pill: true).with_content("Badge"))
  end

  # @label Info
  def pill_info
    render(Flowbite::BadgeComponent.new(color: :info, pill: true).with_content("Badge"))
  end

  # @label Success
  def pill_success
    render(Flowbite::BadgeComponent.new(color: :success, pill: true).with_content("Badge"))
  end

  # @label Warning
  def pill_warning
    render(Flowbite::BadgeComponent.new(color: :warning, pill: true).with_content("Badge"))
  end

  # @label Error
  def pill_error
    render(Flowbite::BadgeComponent.new(color: :error, pill: true).with_content("Badge"))
  end

  # @!endgroup

  # @!group Border

  # @label Neutral (Default)
  def border_neutral
    render(Flowbite::BadgeComponent.new(color: :neutral, border: true).with_content("Badge"))
  end

  # @label Dark
  def border_dark
    render(Flowbite::BadgeComponent.new(color: :dark, border: true).with_content("Badge"))
  end

  # @label Light
  def border_light
    render(Flowbite::BadgeComponent.new(color: :light, border: true).with_content("Badge"))
  end

  # @label Red
  def border_red
    render(Flowbite::BadgeComponent.new(color: :red, border: true).with_content("Badge"))
  end

  # @label Blue
  def border_blue
    render(Flowbite::BadgeComponent.new(color: :blue, border: true).with_content("Badge"))
  end

  # @label Green
  def border_green
    render(Flowbite::BadgeComponent.new(color: :green, border: true).with_content("Badge"))
  end

  # @label Yellow
  def border_yellow
    render(Flowbite::BadgeComponent.new(color: :yellow, border: true).with_content("Badge"))
  end

  # @label Indigo
  def border_indigo
    render(Flowbite::BadgeComponent.new(color: :indigo, border: true).with_content("Badge"))
  end

  # @label Purple
  def border_purple
    render(Flowbite::BadgeComponent.new(color: :purple, border: true).with_content("Badge"))
  end

  # @label Pink
  def border_pink
    render(Flowbite::BadgeComponent.new(color: :pink, border: true).with_content("Badge"))
  end

  # @label Info
  def border_info
    render(Flowbite::BadgeComponent.new(color: :info, border: true).with_content("Badge"))
  end

  # @label Success
  def border_success
    render(Flowbite::BadgeComponent.new(color: :success, border: true).with_content("Badge"))
  end

  # @label Warning
  def border_warning
    render(Flowbite::BadgeComponent.new(color: :warning, border: true).with_content("Badge"))
  end

  # @label Error
  def border_error
    render(Flowbite::BadgeComponent.new(color: :error, border: true).with_content("Badge"))
  end
  
  # @!endgroup
  
  # @!group With Icon

  def default_with_icon
    render(Flowbite::BadgeComponent.new) do |c|
      c.with_icon "tag"
      "Category"
    end
  end

  def pill_with_icon
    render(Flowbite::BadgeComponent.new(pill: true)) do |c|
      c.with_icon "tag"
      "Category"
    end
  end

  # @!endgroup
  
  # @!group As Link

  # @label Neutral (Default)
  def url_neutral
    render(Flowbite::BadgeComponent.new(color: :neutral, url: "#").with_content("Badge"))
  end

  # @label Dark
  def url_dark
    render(Flowbite::BadgeComponent.new(color: :dark, url: "#").with_content("Badge"))
  end

  # @label Light
  def url_light
    render(Flowbite::BadgeComponent.new(color: :light, url: "#").with_content("Badge"))
  end

  # @label Red
  def url_red
    render(Flowbite::BadgeComponent.new(color: :red, url: "#").with_content("Badge"))
  end

  # @label Blue
  def url_blue
    render(Flowbite::BadgeComponent.new(color: :blue, url: "#").with_content("Badge"))
  end

  # @label Green
  def url_green
    render(Flowbite::BadgeComponent.new(color: :green, url: "#").with_content("Badge"))
  end

  # @label Yellow
  def url_yellow
    render(Flowbite::BadgeComponent.new(color: :yellow, url: "#").with_content("Badge"))
  end

  # @label Indigo
  def url_indigo
    render(Flowbite::BadgeComponent.new(color: :indigo, url: "#").with_content("Badge"))
  end

  # @label Purple
  def url_purple
    render(Flowbite::BadgeComponent.new(color: :purple, url: "#").with_content("Badge"))
  end

  # @label Pink
  def url_pink
    render(Flowbite::BadgeComponent.new(color: :pink, url: "#").with_content("Badge"))
  end

  # @label Info
  def url_info
    render(Flowbite::BadgeComponent.new(color: :info, url: "#").with_content("Badge"))
  end

  # @label Success
  def url_success
    render(Flowbite::BadgeComponent.new(color: :success, url: "#").with_content("Badge"))
  end

  # @label Warning
  def url_warning
    render(Flowbite::BadgeComponent.new(color: :warning, url: "#").with_content("Badge"))
  end

  # @label Error
  def url_error
    render(Flowbite::BadgeComponent.new(color: :error, url: "#").with_content("Badge"))
  end
  
  # @!endgroup
end
