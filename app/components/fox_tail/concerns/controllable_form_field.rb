# frozen_string_literal: true

module FoxTail::Concerns::ControllableFormField
  extend ActiveSupport::Concern

  included do
    has_option :controlled, type: :boolean, default: false

    stimulated_with [:fox_tail, :form_field], as: :form_field, if: :controlled?
  end
end
