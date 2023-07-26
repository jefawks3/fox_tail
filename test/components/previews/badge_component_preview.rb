# frozen_string_literal: true

class BadgeComponentPreview < ViewComponent::Preview
  ICON = "check-circle"

  def default
    render(Flowbite::BadgeComponent.new.with_content("Default"))
  end

  %i[base sm].each do |size|
    define_method :"#{size}_badge" do
      render(Flowbite::BadgeComponent.new(size: size).with_content("#{size.to_s.upcase} Badge"))
    end

    define_method :"#{size}_badge_icon_only" do
      render(Flowbite::BadgeComponent.new(size: size, icon_only: true)) do |c|
        c.with_icon ICON
        size.to_s.upcase
      end
    end

    define_method :"#{size}_badge_with_icon" do
      render(Flowbite::BadgeComponent.new(size: size)) do |c|
        c.with_icon ICON
        size.to_s.upcase
      end
    end

    define_method :"#{size}_badge_pill" do
      render(Flowbite::BadgeComponent.new(size: size, pill: true).with_content("#{size.to_s.upcase} Badge"))
    end

    define_method :"#{size}_badge_pill_with_icon" do
      render(Flowbite::BadgeComponent.new(size: size, pill: true)) do |c|
        c.with_icon ICON
        size.to_s.upcase
      end
    end

    define_method :"#{size}_bordered_badge" do
      render(Flowbite::BadgeComponent.new(size: size, border: true).with_content("#{size.to_s.upcase} Badge"))
    end

    define_method :"#{size}_bordered_badge_with_icon" do
      render(Flowbite::BadgeComponent.new(size: size, border: true)) do |c|
        c.with_icon ICON
        size.to_s.upcase
      end
    end

    define_method :"#{size}_bordered_badge_pill" do
      render(Flowbite::BadgeComponent.new(size: size, border: true, pill: true).with_content("#{size.to_s.upcase} Badge"))
    end

    define_method :"#{size}_bordered_badge_pill_with_icon" do
      render(Flowbite::BadgeComponent.new(size: size, border: true, pill: true)) do |c|
        c.with_icon ICON
        size.to_s.upcase
      end
    end
  end

  %i[default neutral dark light info success warning error red blue yellow green indigo purple pink].each do |color|
    define_method :"#{color}_badge" do
      render(Flowbite::BadgeComponent.new(color: color).with_content(color.capitalize))
    end

    define_method :"#{color}_badge_with_icon" do
      render(Flowbite::BadgeComponent.new(color: color)) do |c|
        c.with_icon(ICON)
        color.to_s.capitalize
      end
    end

    define_method :"#{color}_badge_icon_only" do
      render(Flowbite::BadgeComponent.new(color: color, icon_only: true)) do |c|
        c.with_icon ICON
        color.to_s.capitalize
      end
    end

    define_method :"#{color}_badge_pill" do
      render(Flowbite::BadgeComponent.new(color: color, pill: true).with_content(color.capitalize))
    end

    define_method :"#{color}_badge_pill_with_icon" do
      render(Flowbite::BadgeComponent.new(color: color, pill: true)) do |c|
        c.with_icon(ICON)
        color.to_s.capitalize
      end
    end

    define_method :"#{color}_bordered_badge" do
      render(Flowbite::BadgeComponent.new(color: color, border: true).with_content(color.capitalize))
    end

    define_method :"#{color}_bordered_badge_icon_only" do
      render(Flowbite::BadgeComponent.new(color: color, border: true, icon_only: true)) do |c|
        c.with_icon ICON
        color.to_s.capitalize
      end
    end

    define_method :"#{color}_bordered_badge_with_icon" do
      render(Flowbite::BadgeComponent.new(color: color, border: true)) do |c|
        c.with_icon(ICON)
        color.to_s.capitalize
      end
    end

    define_method :"#{color}_bordered_badge_pill" do
      render(Flowbite::BadgeComponent.new(color: color, border: true, pill: true).with_content(color.capitalize))
    end

    define_method :"#{color}_bordered_badge_pill_with_icon" do
      render(Flowbite::BadgeComponent.new(color: color, border: true, pill: true)) do |c|
        c.with_icon(ICON)
        color.to_s.capitalize
      end
    end

    define_method :"#{color}_link_badge" do
      render(Flowbite::BadgeComponent.new(color: color, url: "#").with_content(color.capitalize))
    end

    define_method :"#{color}_link_badge_with_icon" do
      render(Flowbite::BadgeComponent.new(color: color, url: "#")) do |c|
        c.with_icon(ICON)
        color.to_s.capitalize
      end
    end

    define_method :"#{color}_link_badge_icon_only" do
      render(Flowbite::BadgeComponent.new(color: color, url: "#", icon_only: true)) do |c|
        c.with_icon(ICON)
        color.to_s.capitalize
      end
    end

    define_method :"#{color}_link_badge_pill" do
      render(Flowbite::BadgeComponent.new(color: color, url: "#", pill: true).with_content(color.capitalize))
    end

    define_method :"#{color}_link_badge_pill_with_icon" do
      render(Flowbite::BadgeComponent.new(color: color, url: "#", pill: true)) do |c|
        c.with_icon(ICON)
        color.to_s.capitalize
      end
    end

    define_method :"#{color}_link_bordered_badge" do
      render(Flowbite::BadgeComponent.new(color: color, url: "#", border: true).with_content(color.capitalize))
    end

    define_method :"#{color}_link_bordered_badge_with_icon" do
      render(Flowbite::BadgeComponent.new(color: color, url: "#", border: true)) do |c|
        c.with_icon(ICON)
        color.to_s.capitalize
      end
    end

    define_method :"#{color}_link_bordered_badge_icon_only" do
      render(Flowbite::BadgeComponent.new(color: color, url: "#", border: true, icon_only: true)) do |c|
        c.with_icon(ICON)
        color.to_s.capitalize
      end
    end

    define_method :"#{color}_link_bordered_badge_pill" do
      render(Flowbite::BadgeComponent.new(color: color, url: "#", border: true, pill: true).with_content(color.capitalize))
    end

    define_method :"#{color}_link_bordered_badge_pill_with_icon" do
      render(Flowbite::BadgeComponent.new(color: color, url: "#", border: true, pill: true)) do |c|
        c.with_icon(ICON)
        color.to_s.capitalize
      end
    end
  end
end
