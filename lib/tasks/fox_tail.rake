# frozen_string_literal: true

namespace :fox_tail do
  # Get the root directory for the gem
  task which: :environment do
    puts FoxTail.root
  end
end
