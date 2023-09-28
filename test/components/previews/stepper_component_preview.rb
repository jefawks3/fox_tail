# frozen_string_literal: true

# @logical_path components
# @component Flowbite::StepperComponent
class StepperComponentPreview < ViewComponent::Preview

  # @!group Default
  def default_with_labels
    render Flowbite::StepperComponent.new(variant: :default) do |c|
      c.with_step(state: :completed) do
        'Personal <span class="hidden sm:inline ml-2">Info</span>'.html_safe
      end
      c.with_step(state: :current) do
        'Account <span class="hidden sm:inline ml-2">Info</span>'.html_safe
      end
      c.with_step do |s|
        s.with_icon "envelope"
        "Confirmation"
      end
      c.with_step_content "Finished"
    end
  end

  def default_without_labels
    render Flowbite::StepperComponent.new(variant: :default) do |c|
      c.with_step(state: :completed)
      c.with_step(state: :current)
      c.with_step do |s|
        s.with_icon "envelope"
      end
      c.with_step
    end
  end

  # @!endgroup

  # @!group Progress
  def progress_with_labels
    render Flowbite::StepperComponent.new(variant: :progress) do |c|
      c.with_step(state: :completed) do
        'Personal <span class="hidden sm:inline ml-2">Info</span>'.html_safe
      end
      c.with_step(state: :current) do
        'Account <span class="hidden sm:inline ml-2">Info</span>'.html_safe
      end
      c.with_step do |s|
        s.with_icon "envelope"
        "Confirmation"
      end
      c.with_step_content "Finished"
    end
  end

  def progress_without_labels
    render Flowbite::StepperComponent.new(variant: :progress) do |c|
      c.with_step(state: :completed)
      c.with_step(state: :current)
      c.with_step do |s|
        s.with_icon "envelope"
      end
      c.with_step
    end
  end

  # @!endgroup

  def detailed
    render Flowbite::StepperComponent.new(variant: :detailed) do |c|
      c.with_step(state: :completed) do
        <<~HTML.html_safe
          <h3 class="font-medium leading-tight">User info</h3>
          <p class="text-sm">Step details here</p>
        HTML
      end
      c.with_step(state: :current) do
        <<~HTML.html_safe
          <h3 class="font-medium leading-tight">Company info</h3>
          <p class="text-sm">Step details here</p>
        HTML
      end
      c.with_step do |s|
        s.with_icon "credit-card"
        <<~HTML.html_safe
          <h3 class="font-medium leading-tight">Payment info</h3>
          <p class="text-sm">Step details here</p>
        HTML
      end
      c.with_step do
        <<~HTML.html_safe
          <h3 class="font-medium leading-tight">Review info</h3>
          <p class="text-sm">Step details here</p>
        HTML
      end
    end
  end

  def vertical
    render Flowbite::StepperComponent.new(variant: :vertical) do |c|
      c.with_step(state: :completed).with_content("Personal Info")
      c.with_step(state: :current).with_content("Account Info")
      c.with_step_content "Review"
      c.with_step_content "Finished"
    end
  end

  def breadcrumb
    render Flowbite::StepperComponent.new(variant: :breadcrumb) do |c|
      c.with_step(state: :completed) do
        'Personal <span class="hidden sm:inline ml-2">Info</span>'.html_safe
      end
      c.with_step(state: :current) do
        'Account <span class="hidden sm:inline ml-2">Info</span>'.html_safe
      end
      c.with_step do |s|
        s.with_icon "envelope"
        "Confirmation"
      end
      c.with_step_content "Finished"
    end
  end

  def timeline
    render Flowbite::StepperComponent.new(variant: :timeline) do |c|
      c.with_step(state: :completed) do
        <<~HTML.html_safe
          <h3 class="font-medium leading-tight">User info</h3>
          <p class="text-sm">Step details here</p>
        HTML
      end
      c.with_step(state: :current) do
        <<~HTML.html_safe
          <h3 class="font-medium leading-tight">Company info</h3>
          <p class="text-sm">Step details here</p>
        HTML
      end
      c.with_step do |s|
        s.with_icon "credit-card"
        <<~HTML.html_safe
          <h3 class="font-medium leading-tight">Payment info</h3>
          <p class="text-sm">Step details here</p>
        HTML
      end
      c.with_step do
        <<~HTML.html_safe
          <h3 class="font-medium leading-tight">Review info</h3>
          <p class="text-sm">Step details here</p>
        HTML
      end
    end
  end
end
