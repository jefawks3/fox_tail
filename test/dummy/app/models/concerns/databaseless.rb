# frozen_string_literal: true

module Databaseless
  extend ActiveSupport::Concern
  include ActiveModel::Model

  included do
    delegate_missing_to :attributes
  end

  def errors
    @errors ||= ActiveModel::Errors.new self
  end

  def attributes
    @attributes ||= ActiveSupport::OrderedOptions.new
  end
end
