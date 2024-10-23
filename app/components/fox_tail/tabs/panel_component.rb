# frozen_string_literal: true

class FoxTail::Tabs::PanelComponent < FoxTail::CollapsibleComponent
  class << self
    def stimulus_controller_name
      :collapsible
    end
  end
end
