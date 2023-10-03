# frozen_string_literal: true

class Flowbite::Pagination::PageComponent < Flowbite::ClickableComponent
  has_option :current_page, type: :boolean, default: false
end
