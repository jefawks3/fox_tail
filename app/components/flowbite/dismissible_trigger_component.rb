# frozen_string_literal: true

class Flowbite::DismissibleTriggerComponent < Flowbite::TriggerBaseComponent
  def trigger_type
    options[:trigger_type] ||= :click
  end

  class StimulusController < Flowbite::ViewComponents::StimulusController
    def attributes(options = {})
      attributes = super options
      attributes[:data][outlet_key(:dismissible)] = options[:selector]
      attributes[:data][:action] = action(:dismiss) if options[:trigger_type] == :click
      attributes
    end
  end
end
