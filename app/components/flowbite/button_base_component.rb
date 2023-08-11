# frozen_string_literal: true

class Flowbite::ButtonBaseComponent < Flowbite::ClickableComponent
  has_option :variant, default: :solid
  has_option :size, default: :base
  has_option :color, default: :default
  has_option :pill, default: false, type: :boolean
end
