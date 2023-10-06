# frozen_string_literal: true

# @logical_path components
# @component FoxTail::TimelineComponent
# @component FoxTail::Timeline::EntryComponent
class TimelineComponentPreview < ViewComponent::Preview

  # @!group Visuals

  def dot_indicator
    render FoxTail::TimelineComponent.new do |t|
      t.with_entry do |e|
        e.capture do
          e.concat e.time_tag(Date.today - 10.days, class: "mb-1 text-sm font-normal leading-none text-gray-400 dark:text-gray-500")
          e.concat e.content_tag(:h3, Faker::Books::Lovecraft.tome, class: "text-lg font-semibold text-gray-900 dark:text-white")
          e.concat e.content_tag(:p, Faker::Books::Lovecraft.paragraph, class: "mb-4 text-base font-normal text-gray-500 dark:text-gray-400")
        end
      end
      t.with_entry do |e|
        e.with_dot_indicator color: :blue, animated: true
        e.capture do
          e.concat e.time_tag(Date.today - 20.days, class: "mb-1 text-sm font-normal leading-none text-gray-400 dark:text-gray-500")
          e.concat e.content_tag(:h3, Faker::Books::Lovecraft.tome, class: "text-lg font-semibold text-gray-900 dark:text-white")
          e.concat e.content_tag(:p, Faker::Books::Lovecraft.paragraph, class: "mb-4 text-base font-normal text-gray-500 dark:text-gray-400")
        end
      end
      t.with_entry do |e|
        e.capture do
          e.concat e.time_tag(Date.today - 100.days, class: "mb-1 text-sm font-normal leading-none text-gray-400 dark:text-gray-500")
          e.concat e.content_tag(:h3, Faker::Books::Lovecraft.tome, class: "text-lg font-semibold text-gray-900 dark:text-white")
          e.concat e.content_tag(:p, Faker::Books::Lovecraft.paragraph, class: "mb-4 text-base font-normal text-gray-500 dark:text-gray-400")
        end
      end
    end
  end

  def icons
    render FoxTail::TimelineComponent.new do |t|
      t.with_entry do |e|
        e.with_icon
        e.capture do
          e.concat e.time_tag(Date.today - 10.days, class: "mb-1 text-sm font-normal leading-none text-gray-400 dark:text-gray-500")
          e.concat e.content_tag(:h3, Faker::Books::Lovecraft.tome, class: "text-lg font-semibold text-gray-900 dark:text-white")
          e.concat e.content_tag(:p, Faker::Books::Lovecraft.paragraph, class: "mb-4 text-base font-normal text-gray-500 dark:text-gray-400")
        end
      end
      t.with_entry do |e|
        e.with_icon "cake"
        e.capture do
          e.concat e.time_tag(Date.today - 20.days, class: "mb-1 text-sm font-normal leading-none text-gray-400 dark:text-gray-500")
          e.concat e.content_tag(:h3, Faker::Books::Lovecraft.tome, class: "text-lg font-semibold text-gray-900 dark:text-white")
          e.concat e.content_tag(:p, Faker::Books::Lovecraft.paragraph, class: "mb-4 text-base font-normal text-gray-500 dark:text-gray-400")
        end
      end
      t.with_entry do |e|
        e.with_icon
        e.capture do
          e.concat e.time_tag(Date.today - 100.days, class: "mb-1 text-sm font-normal leading-none text-gray-400 dark:text-gray-500")
          e.concat e.content_tag(:h3, Faker::Books::Lovecraft.tome, class: "text-lg font-semibold text-gray-900 dark:text-white")
          e.concat e.content_tag(:p, Faker::Books::Lovecraft.paragraph, class: "mb-4 text-base font-normal text-gray-500 dark:text-gray-400")
        end
      end
    end
  end

  def images
    render FoxTail::TimelineComponent.new do |t|
      t.with_entry do |e|
        e.with_image "users/bonnie-green.png"
        e.capture do
          e.concat e.time_tag(Date.today - 10.days, class: "mb-1 text-sm font-normal leading-none text-gray-400 dark:text-gray-500")
          e.concat e.content_tag(:h3, Faker::Books::Lovecraft.tome, class: "text-lg font-semibold text-gray-900 dark:text-white")
          e.concat e.content_tag(:p, Faker::Books::Lovecraft.paragraph, class: "mb-4 text-base font-normal text-gray-500 dark:text-gray-400")
        end
      end
      t.with_entry do |e|
        e.with_image "users/neil-sims.png"
        e.capture do
          e.concat e.time_tag(Date.today - 20.days, class: "mb-1 text-sm font-normal leading-none text-gray-400 dark:text-gray-500")
          e.concat e.content_tag(:h3, Faker::Books::Lovecraft.tome, class: "text-lg font-semibold text-gray-900 dark:text-white")
          e.concat e.content_tag(:p, Faker::Books::Lovecraft.paragraph, class: "mb-4 text-base font-normal text-gray-500 dark:text-gray-400")
        end
      end
      t.with_entry do |e|
        e.with_image "users/lana-byrd.png"
        e.capture do
          e.concat e.time_tag(Date.today - 100.days, class: "mb-1 text-sm font-normal leading-none text-gray-400 dark:text-gray-500")
          e.concat e.content_tag(:h3, Faker::Books::Lovecraft.tome, class: "text-lg font-semibold text-gray-900 dark:text-white")
          e.concat e.content_tag(:p, Faker::Books::Lovecraft.paragraph, class: "mb-4 text-base font-normal text-gray-500 dark:text-gray-400")
        end
      end
    end
  end

  # @!endgroup

  def stepper
    render FoxTail::TimelineComponent.new vertical: false do |t|
      t.with_entry do |e|
        e.with_icon
        e.capture do
          e.concat e.time_tag(Date.today - 10.days, class: "mb-1 text-sm font-normal leading-none text-gray-400 dark:text-gray-500")
          e.concat e.content_tag(:h3, Faker::Books::Lovecraft.tome, class: "text-lg font-semibold text-gray-900 dark:text-white")
          e.concat e.content_tag(:p, Faker::Books::Lovecraft.paragraph, class: "mb-4 text-base font-normal text-gray-500 dark:text-gray-400")
        end
      end
      t.with_entry do |e|
        e.with_icon "cake"
        e.capture do
          e.concat e.time_tag(Date.today - 20.days, class: "mb-1 text-sm font-normal leading-none text-gray-400 dark:text-gray-500")
          e.concat e.content_tag(:h3, Faker::Books::Lovecraft.tome, class: "text-lg font-semibold text-gray-900 dark:text-white")
          e.concat e.content_tag(:p, Faker::Books::Lovecraft.paragraph, class: "mb-4 text-base font-normal text-gray-500 dark:text-gray-400")
        end
      end
      t.with_entry do |e|
        e.with_icon
        e.capture do
          e.concat e.time_tag(Date.today - 100.days, class: "mb-1 text-sm font-normal leading-none text-gray-400 dark:text-gray-500")
          e.concat e.content_tag(:h3, Faker::Books::Lovecraft.tome, class: "text-lg font-semibold text-gray-900 dark:text-white")
          e.concat e.content_tag(:p, Faker::Books::Lovecraft.paragraph, class: "mb-4 text-base font-normal text-gray-500 dark:text-gray-400")
        end
      end
    end
  end
end
