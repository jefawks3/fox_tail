# frozen_string_literal: true

module FoxTail::Concerns::Identifiable
  extend ActiveSupport::Concern

  class_methods do
    def generate_unique_id
      "#{name.underscore.gsub("_component", "").gsub("/", "_")}_#{SecureRandom.base58(6)}"
    end
  end

  def id
    html_attributes[:id] ||= self.class.generate_unique_id
  end
  alias_method :generate_unique_id, :id

  private

  def __id_argument_deprecated_warning(slot: false)
    FoxTail.deprecator.allow ['identifiable'] do
      callstack = Array(caller_locations[slot ? 7 : 4])
      FoxTail.deprecator.warn "first argument `id` is deprecated, use `id:` instead", callstack
    end
  end
end
