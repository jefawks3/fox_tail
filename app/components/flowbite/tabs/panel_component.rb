# frozen_string_literal: true

class Flowbite::Tabs::PanelComponent < Flowbite::CollapsibleComponent

  class << self
    def stimulus_controller_name
      :collapsible
    end
  end
end
