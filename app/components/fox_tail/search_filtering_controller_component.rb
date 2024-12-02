# frozen_string_literal: true

class FoxTail::SearchFilteringControllerComponent < FoxTail::WrapperComponent
  has_option :preset
  has_option :tokenize
  has_option :limit
  has_option :length
  has_option :delay

  stimulated_with [:fox_tail, :search_filtering], as: :search_filtering do |controller|
    controller.with_value :preset, preset
    controller.with_value :tokenize, tokenize
    controller.with_value :limit, limit
    controller.with_value :length, length
    controller.with_value :delay, delay
    controller.with_class :visible, theme.apply("root/visible", self)
    controller.with_class :hidden, theme.apply("root/hidden", self)
  end
end
