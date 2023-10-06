# frozen_string_literal: true

class FoxTail::Pagination::PageComponent < FoxTail::ClickableComponent
  has_option :current_page, type: :boolean, default: false
end
