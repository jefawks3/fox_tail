# frozen_string_literal: true

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"
require "rails/generators/test_case"

ViewComponent::Base.config.view_component_path = "app/components"

ActiveSupport.on_load(:active_support_test_case) do
  self.fixture_paths = [File.expand_path("fixtures", __dir__)]
  self.file_fixture_path = File.join(File.expand_path("fixtures", __dir__), "files")
  # fixtures :all
end
