# frozen_string_literal: true

class FoxTail::HistoryControllerComponent < FoxTail::WrapperComponent
  has_option :path
  has_option :title

  stimulated_with [:fox_tail, :history], as: :history do |controller|
    controller.with_value :path, path
    controller.with_value :title, title
  end
end
